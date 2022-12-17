package e2e

import (
	"bytes"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/http/cookiejar"
)

const host = "localhost"

func getClient() *http.Client {
	jar, err := cookiejar.New(nil)
	if err != nil {
		panic(err)
	}

	tr := &http.Transport{
		TLSClientConfig: &tls.Config{
			ServerName:         "ingress.local",
			InsecureSkipVerify: true,
		},
	}

	return &http.Client{Jar: jar, Transport: tr}
}

var client = getClient()

type getAPI[R any] struct {
	path   string
	secure bool
}

func NewGetAPI[R any](path string) getAPI[R] {
	return getAPI[R]{path: path, secure: true}
}

func NewUnsecureGetAPI[R any](path string) getAPI[R] {
	return getAPI[R]{path: path, secure: false}
}

func (api getAPI[R]) getURL() string {
	if api.secure {
		return fmt.Sprintf("https://%s%s", host, api.path)
	}
	return fmt.Sprintf("http://%s%s", host, api.path)
}

func (api getAPI[R]) Request() (*R, error) {
	resp, err := client.Get(api.getURL())
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return nil, fmt.Errorf("wrong status code: %v", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	var r R
	if err := json.Unmarshal(body, &r); err != nil {
		return nil, err
	}
	return &r, nil
}

type postAPI[B any, R any] struct {
	path string
}

func NewPostAPI[B any, R any](path string) postAPI[B, R] {
	return postAPI[B, R]{path}
}

func (api postAPI[B, R]) getURL() string {
	return fmt.Sprintf("https://%s%s", host, api.path)
}

func (api postAPI[B, R]) Request(b B) (*R, error) {
	bs, err := json.Marshal(b)
	if err != nil {
		return nil, err
	}

	resp, err := client.Post(api.getURL(), "application/json", bytes.NewBuffer(bs))
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return nil, fmt.Errorf("wrong status code: %v", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}
	if len(body) == 0 {
		return nil, nil
	}
	var r R
	if err := json.Unmarshal(body, &r); err != nil {
		return nil, err
	}
	return &r, nil
}
