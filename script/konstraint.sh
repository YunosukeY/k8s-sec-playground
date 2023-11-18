#!/usr/bin/env bash

set -eu

os="$(uname -s)"
machine=$([[ $(uname -m) == arm64 ]] && echo arm64 || echo amd64)
version="v0.31.0"
repo_dir="$(git rev-parse --show-toplevel)"
bin="${repo_dir}/bin"
konstraint="${bin}/konstraint"


if [[ -x "${konstraint}" ]]; then
  true
else
  mkdir -p "${bin}"
  echo "download konstraint ${version}"
  url="https://github.com/plexsystems/konstraint/releases/download/${version}/konstraint-${os}-${machine}"
  curl -sfSL "$url" > "${konstraint}"
  chmod +x "${konstraint}"
fi

"${konstraint}" "${@}"
