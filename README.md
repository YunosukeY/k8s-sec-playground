# K8s Security Playground on kind

[![conftest](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/conftest.yaml/badge.svg?branch=master&event=push)](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/conftest.yaml)
[![yamllint](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/yamllint.yaml/badge.svg?branch=master&event=push)](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/yamllint.yaml)
[![golangci-lint](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/golangci-lint.yml/badge.svg?branch=master&event=push)](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/golangci-lint.yml)
[![kind e2e](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/kind-e2e.yaml/badge.svg?branch=master&event=push)](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/kind-e2e.yaml)
[![Renovate](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com)

## Features

- Private Registry
- Gatekeeper and Conftest
- Calico
- TLS Ingress and mTLS
- Authn (X509 Client Certs) and RBAC Authz
- External Secrets Operator
- Traffic Control

<!--
## Usage

### Requirement

- kubectl
- kind
- Go
- Helm, Helmfile, helm-diff

### Preparation

1. Push an image to DockerHub<br>
   See https://github.com/YunosukeY/k8s-playground-backend#preparation-for-kind-sample
2. Create .env.dockerhub file

```sh
cat <<EOF > .env.dockerhub
DOCKER_USERNAME={DOCKERHUB_USERNAME}
DOCKER_PASSWORD={DOCKERHUB_PASSWORD}
EOF
```

3. Update images in `k8s/app/kustomization.yaml` with your own image.

### To Create a Cluster

```sh
./kind/e2e.sh create
```

### To Run E2E Test

```sh
go test cmd/e2e/main_test.go
```

### To Delete the Cluster

```sh
./e2d.sh delete
``` -->
