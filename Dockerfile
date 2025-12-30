# ---------- base ----------
FROM debian:12.12-slim@sha256:d5d3f9c23164ea16f31852f95bd5959aad1c5e854332fe00f7b3a20fcc9f635c AS base

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates curl git unzip xz-utils gnupg bash \
  && rm -rf /var/lib/apt/lists/*

# install mise
ENV MISE_VERSION=v2025.11.10
ENV MISE_DATA_DIR="/mise"
ENV MISE_CONFIG_DIR="/mise"
ENV MISE_CACHE_DIR="/mise/cache"
ENV MISE_INSTALL_PATH="/usr/local/bin/mise"
ENV PATH="/mise/shims:$PATH"

RUN curl -fsSL https://mise.run | sh

WORKDIR /root
COPY mise.toml /root/mise.toml

RUN mise trust /root/mise.toml \
  && mise install just jq yq trivy sops age

CMD ["bash"]

# ---------- k8s ----------
FROM base AS k8s

RUN mise install kubectl helm

# ---------- docker ----------
FROM base AS docker

RUN mise install docker-cli docker-compose docker-slim

RUN printf '#!/bin/sh\nexec docker-cli-plugin-docker-compose "$@"\n' \
  > /usr/local/bin/docker-compose \
  && chmod +x /usr/local/bin/docker-compose

# ---------- iac ----------
FROM base AS iac

RUN mise install python pipx ansible terraform sst

RUN sst version || true

# ---------- dev ----------
FROM base AS dev

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  && rm -rf /var/lib/apt/lists/*

RUN mise install uv bun go rust
