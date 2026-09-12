#!/usr/bin/env bash
# Build Hugo Extended + Oink on Vercel. Versions match .github/workflows/pages.yml.

set -euo pipefail

GO_VERSION=1.26.6
HUGO_VERSION=0.164.0

export GOWORK=off
export HUGO_MODULE_WORKSPACE=off
export HUGO_CACHEDIR="${PWD}/.vercel/cache/hugo"
export TZ=Asia/Shanghai

cleanup() {
  if [[ -n "${build_temp_dir:-}" && -d "${build_temp_dir}" ]]; then
    rm -rf "${build_temp_dir}"
  fi
}

trap cleanup EXIT

main() {
  mkdir -p "${HOME}/.local" "${HUGO_CACHEDIR}"
  build_temp_dir=$(mktemp -d)

  echo "Installing Go ${GO_VERSION}..."
  curl -sfL --output-dir "${build_temp_dir}" -O \
    "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
  tar -C "${HOME}/.local" -xf "${build_temp_dir}/go${GO_VERSION}.linux-amd64.tar.gz"
  export PATH="${HOME}/.local/go/bin:${PATH}"

  echo "Installing Hugo Extended ${HUGO_VERSION}..."
  curl -sfL --output-dir "${build_temp_dir}" -O \
    "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
  mkdir -p "${HOME}/.local/hugo"
  tar -C "${HOME}/.local/hugo" -xf \
    "${build_temp_dir}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"
  export PATH="${HOME}/.local/hugo:${PATH}"

  echo "Go: $(go version)"
  echo "Hugo: $(hugo version)"

  git config core.quotepath false

  if [[ $(git rev-parse --is-shallow-repository) == true ]]; then
    echo "Fetching full Git history for enableGitInfo..."
    git fetch --unshallow
  fi

  echo "Downloading Hugo module github.com/pgsty/oink..."
  go mod download github.com/pgsty/oink

  echo "Verifying advertised and pinned release match..."
  node scripts/check-release-pin.mjs

  local base_url
  if [[ "${VERCEL_ENV:-}" == "production" && -n "${VERCEL_PROJECT_PRODUCTION_URL:-}" ]]; then
    base_url="https://${VERCEL_PROJECT_PRODUCTION_URL}/"
  elif [[ -n "${VERCEL_URL:-}" ]]; then
    base_url="https://${VERCEL_URL}/"
  else
    echo "VERCEL_URL is not set; cannot determine baseURL" >&2
    exit 1
  fi

  echo "Building with baseURL ${base_url}"
  export HUGO_PARAMS_PRODUCTIONURL="${base_url}"

  hugo --cleanDestinationDir --gc --minify --environment production \
    --printPathWarnings --panicOnWarning \
    --baseURL "${base_url}"
}

main "$@"
