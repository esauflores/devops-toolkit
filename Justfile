REGISTRY := "ghcr.io/esauflores/devops-toolkit"
VERSION  := "1.0"
TARGETS  := "base k8s docker iac dev"

default:
  @just --list

# Build Docker images (all or selected targets)
build *targets='':
  #!/usr/bin/env bash
  set -e
  for t in {{ if targets == '' { TARGETS } else { targets } }}; do
    echo "🔨 Building $t"
    docker build --target $t -t {{REGISTRY}}:$t -t {{REGISTRY}}:{{VERSION}}-$t .
  done

# Push Docker images to registry (all or selected images)
push *targets='':
  #!/usr/bin/env bash
  set -e
  for t in {{ if targets == '' { TARGETS } else { targets } }}; do
    echo "📦 Pushing $t"
    docker push {{REGISTRY}}:$t
    docker push {{REGISTRY}}:{{VERSION}}-$t
  done

# Build and push Docker images (all or selected targets)
release *targets='': (build targets) (push targets)

# Test Docker images 
test *targets='':
  #!/usr/bin/env bash
  set -e
  for t in {{ if targets == '' { TARGETS } else { targets } }}; do
    echo "🧪 Testing $t"
    case $t in
      base)
        docker run --rm {{REGISTRY}}:$t bash -c "just --version && jq --version && trivy --version && sops --version && age --version"
        ;;
      k8s)
        docker run --rm {{REGISTRY}}:$t bash -c "kubectl version --client && helm version"
        ;;
      docker)
        docker run --rm {{REGISTRY}}:$t bash -c "docker --version && docker-compose --version"
        ;;
      iac)
        docker run --rm {{REGISTRY}}:$t bash -c "terraform version && ansible --version && sst version"
        ;;
      dev)
        docker run --rm {{REGISTRY}}:$t bash -c "uv --version && bun --version && go version && rustc --version && gcc --version"
        ;;
    esac
    echo "✅ $t passed"
  done

# check updates for tools
mise-check-updates:
  #!/usr/bin/env bash
  set -e
  echo "🔎 Updates within pinned minor version"
  mise outdated
  echo "🚨 Newer versions available"
  mise outdated -l

# Login to container registry 
login: 
  docker login ghcr.io

