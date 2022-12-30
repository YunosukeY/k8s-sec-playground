# K8s Security Playground on kind

[![conftest](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/conftest.yaml/badge.svg?branch=master&event=push)](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/conftest.yaml)
[![yamllint](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/yamllint.yaml/badge.svg?branch=master&event=push)](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/yamllint.yaml)
[![golangci-lint](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/golangci-lint.yml/badge.svg?branch=master&event=push)](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/golangci-lint.yml)
[![kind e2e](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/kind-e2e.yaml/badge.svg?branch=master&event=push)](https://github.com/YunosukeY/k8s-sec-playground/actions/workflows/kind-e2e.yaml)
[![Renovate](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com)

## Features

### Private Registry

Application images are managed by DockerHub's private repository.

### Pod Security

Pod Security is verified by [Conftest](https://www.conftest.dev) in CI, and by [Gatekeeper](https://open-policy-agent.github.io/gatekeeper) in the cluster.<br>
See [this repository](https://github.com/YunosukeY/policy-for-pss) for policy details.

### Network Policy

Global network policy is managed by [Calico](https://www.tigera.io/project-calico).

### TLS

TLS termination is managed by [Ingress NGINX](https://kubernetes.github.io/ingress-nginx).<br>
mTLS is managed by [Linkerd](https://linkerd.io).

### Authn and Authz

Authentication is enabled with X509 Client Certs.<br>
RBAC authorization is also enabled.

### Secret Management

Secrets are managed by [AWS Secret Manager](https://aws.amazon.com/secrets-manager), and injected by [External Secrets Operator](https://external-secrets.io).

### Traffic Control

Traffic control is managed by [Linkerd](https://linkerd.io).

### Certificate Management

Certificates are managed by [cert-manager](https://cert-manager.io).

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
