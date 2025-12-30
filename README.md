# DevOps Toolkit

A reproducible, Docker-based **DevOps toolchain** powered by **mise** and **just**.
This project bundles commonly used DevOps, Kubernetes, IaC, Docker, and development tools into modular Docker images that are easy to build, test, and publish.

The goal is simple: **consistent tooling, zero local setup pain**.

---

## ✨ Features

- 📦 Multi-stage Docker images (build only what you need)
- 🔁 Reproducible tool versions via `mise.toml`
- 🧰 Opinionated DevOps stack (K8s, IaC, Docker, security tools)
- ⚡ Simple workflows using `just`
- 🧪 Built-in test commands for each image
- 🚀 Ready for CI/CD usage

---

## 📁 Project Structure

```
.
├── Dockerfile      # Multi-stage images (base, k8s, iac, docker, dev)
├── Justfile        # Build, test, push, release workflows
├── mise.toml       # Tool versions (single source of truth)
└── README.md
```

---

## 🧰 Tooling Overview

All tools are pinned via `mise.toml` to ensure deterministic builds.

### Base

- just
- jq / yq
- sops / age
- trivy

### Kubernetes

- kubectl
- helm

### Infrastructure as Code

- python
- pipx
- terraform
- ansible
- sst

### Docker

- docker-cli
- docker-compose
- docker-slim

### Development

- uv
- bun
- go
- rust

---

## 🏗️ Build Images

Build one or more targets using `just`:

```bash
just build base
just build k8s
just build iac
just build docker
just build dev
```

Build all images:

```bash
just build
```

---

## 🧪 Test Images

Each image includes a lightweight validation step to confirm tools are installed correctly.

```bash
just test base
just test k8s
just test iac
just test docker
just test dev
```

Test everything:

```bash
just test
```

---

## 🔐 Reproducibility & Security

- All tools installed via `mise` with explicit versions
- Clean, isolated Docker build stages
- No reliance on host-installed binaries
- Security tooling included by default

---

## 💡 Use Cases

- CI/CD runners
- Local DevOps environments
- Kubernetes & IaC workflows
- Platform engineering toolboxes
- Team-wide standard tooling images

---

## 🛠️ Requirements

- Docker (BuildKit enabled)
- `just` (recommended)
- Internet access during image build

---

## 📌 Notes

- Intentionally opinionated
- Version changes happen only in `mise.toml`
