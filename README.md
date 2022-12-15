# K8s Security Playground on kind

[![conftest](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/conftest.yaml/badge.svg?branch=master&event=push)](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/conftest.yaml)
[![yamllint](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/yamllint.yaml/badge.svg?branch=master&event=push)](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/yamllint.yaml)
[![golangci-lint](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/golangci-lint.yml/badge.svg?branch=master&event=push)](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/golangci-lint.yml)
[![kind e2e](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/kind-e2e.yaml/badge.svg?branch=master&event=push)](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/kind-e2e.yaml)
[![Renovate](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com)

## Usage

### Requirement

- kubectl
- kind
- Go
- Helm, Helmfile, helm-diff

### Preparation

```sh
cat <<EOF > .env.dockerhub
DOCKER_USERNAME={DOCKERHUB_USERNAME}
DOCKER_PASSWORD={DOCKERHUB_PASSWORD}
EOF
```

Also you need to push a image (/backend/Dockerfile) to a specific DockerHub private repository.

### To Create a Cluster

```sh
./kind/e2e.sh create
```

### To Run E2E Test

```sh
cd backend
go test cmd/e2e/main_test.go
```

### To Delete the Cluster

```sh
./e2d.sh delete
```

### Dev Requirement

- yamllint
- conftest
- golangci-lint

## Features

### Security

- Private Registry
- Gatekeeper
- Calico

### Managing Manifests

- Helmfile