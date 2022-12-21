#!/usr/bin/env bash

set -eu

usage() {
  cat <<USAGE
  Usage:
  - e2e.sh create
  - e2e.sh run
  - e2e.sh delete
USAGE
}

if [ "$#" != 1 ]; then
  usage
  exit 1
fi

command="$1"
repo_dir="$(git rev-parse --show-toplevel)"

prepare() {
  ./script/konstraint.sh create .
}

create () {
  kind create cluster --config "${repo_dir}/kind/cluster.yaml"
}

deploy () {
  helmfile apply -f "${repo_dir}/k8s/charts/calico/helmfile.yaml" -e $1

  helmfile apply -f "${repo_dir}/k8s/charts/gatekeeper/helmfile.yaml" -e $1
  kubectl apply -f "${repo_dir}/k8s/app/gatekeeper-config.yaml"
  kubectl apply -f https://raw.githubusercontent.com/YunosukeY/policies-for-pss/master/k8s/template_PodSecurityStandards.yaml -f "${repo_dir}/policy/template.yaml"
  sleep 1 # hack
  kubectl apply -f https://raw.githubusercontent.com/YunosukeY/policies-for-pss/master/k8s/constraint_PodSecurityStandards.yaml -f "${repo_dir}/policy/constraint.yaml"

  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout test.key -out test.crt -subj "/CN=example.com/O=example.com" -addext "subjectAltName = DNS:example.com"
  kubectl create secret tls cert-secret --key test.key --cert test.crt
  helmfile apply -f "${repo_dir}/k8s/charts" -e $1
  kubectl wait --for condition=available deployment/ingress-nginx-controller --namespace=ingress --timeout=300s
  kubectl wait --for condition=available deployment/external-secrets-cert-controller deployment/external-secrets-webhook --namespace=kube-system --timeout=300s

  # deploy app
  kubectl apply -k "${repo_dir}/k8s/app"
}

create_user() {
  # create csr
  openssl genrsa -out myuser.key 2048
  openssl req -new -key myuser.key -out myuser.csr -subj "/CN=myuser"
  cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: myuser
spec:
  request: $(cat myuser.csr | base64 | tr -d "\n")
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400
  usages:
    - client auth
EOF

  # approve
  kubectl certificate approve myuser

  # use user
  kubectl apply -f "${repo_dir}/k8s/app/cluster-role.yaml"
  while [ -z $(kubectl get csr myuser -o jsonpath='{.status.certificate}') ]
  do
    echo "waiting crt..."
    sleep 1
  done
  kubectl get csr myuser -o jsonpath='{.status.certificate}'| base64 -d > myuser.crt
  kubectl config set-credentials myuser --client-key=myuser.key --client-certificate=myuser.crt --embed-certs=true
  kubectl config set-context myuser --cluster=kind-kind --user=myuser
  kubectl config use-context myuser
}

run () {
  kubectl wait --for condition=available deployment/app-deployment deployment/auth-deployment --namespace=app --timeout=600s
  go test cmd/e2e/main_test.go
}

if [ "$command" == "create" ]; then
  prepare
  create
  deploy dev
  create_user
elif [ "$command" == "run" ]; then
  prepare
  create
  deploy ci
  run
elif [ "$command" == "delete" ]; then
  kind delete cluster
else
  usage
  exit 1
fi
