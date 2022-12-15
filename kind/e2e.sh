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

create () {
  kind create cluster --config "${repo_dir}/kind/cluster.yaml"
}

deploy () {
  helmfile apply -f "${repo_dir}/k8s/charts/calico/helmfile.yaml" -e $1

  helmfile apply -f "${repo_dir}/k8s/charts/gatekeeper/helmfile.yaml" -e $1
  kubectl apply -f "${repo_dir}/k8s/app/gatekeeper-config.yaml"
  kubectl apply -f https://raw.githubusercontent.com/YunosukeY/policies-for-pss/master/k8s/template_Policy.yaml
  kubectl apply -f https://raw.githubusercontent.com/YunosukeY/policies-for-pss/master/k8s/constraint_Policy.yaml

  helmfile apply -f "${repo_dir}/k8s/charts" -e $1
  kubectl wait --for condition=available deployment/ingress-nginx-controller --namespace=ingress --timeout=300s

  # deploy app
  kubectl apply -k "${repo_dir}/k8s/app"
  source "${repo_dir}/.env.dockerhub" && kubectl create secret docker-registry registry-key --namespace=app --docker-username=$DOCKER_USERNAME --docker-password=$DOCKER_PASSWORD
}

run () {
  kubectl wait --for condition=available deployment/app-deployment deployment/auth-deployment --namespace=app --timeout=600s
  cd "${repo_dir}/backend"
  go test cmd/e2e/main_test.go
}

if [ "$command" == "create" ]; then
  create
  deploy dev
elif [ "$command" == "run" ]; then
  create
  deploy ci
  run
elif [ "$command" == "delete" ]; then
  kind delete cluster
else
  usage
  exit 1
fi