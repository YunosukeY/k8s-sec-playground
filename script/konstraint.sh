#!/usr/bin/env bash

set -eu

readonly OS="$(uname -s)"
readonly MACHINE=$([[ $(uname -m) == arm64 ]] && echo arm64 || echo amd64)
readonly VERSION="v0.31.0"
readonly REPO_DIR="$(git rev-parse --show-toplevel)"
readonly BIN="${REPO_DIR}/bin"
readonly KONSTRAINT="${BIN}/konstraint"


if [[ -x "${KONSTRAINT}" ]]; then
  true
else
  mkdir -p "${BIN}"
  echo "download konstraint ${VERSION}"
  url="https://github.com/plexsystems/konstraint/releases/download/${VERSION}/konstraint-${OS}-${MACHINE}"
  curl -sfSL "$url" > "${KONSTRAINT}"
  chmod +x "${KONSTRAINT}"
fi

"${KONSTRAINT}" "${@}"
