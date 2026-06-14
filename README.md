# Kubernetes Platform Engineering

[![CI](https://github.com/Jai-Gogineni/kubernetes-platform-engineering/actions/workflows/ci.yml/badge.svg)](https://github.com/Jai-Gogineni/kubernetes-platform-engineering/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Terraform](https://img.shields.io/badge/Terraform-1.6+-623CE4.svg)](https://www.terraform.io/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-1.28+-326CE5.svg)](https://kubernetes.io/)

Production cloud platform toolkit — GKE provisioning with Terraform, Istio service mesh, Prometheus/Grafana observability, canary deployments, and automated release pipelines.

## Architecture

```mermaid
graph TD
    A[Developer Push] --> B[CI Pipeline]
    B --> C[Build & Push Image]
    C --> D[Update K8s Manifests]
    D --> E[Argo CD Sync]
    E --> F[Canary Deploy 10%]
    F --> G{Metrics OK?}
    G -->|Yes| H[Promote to 100%]
    G -->|No| I[Auto Rollback]
    
    subgraph Observability
        J[Prometheus] --> K[Grafana Dashboards]
        J --> L[Alertmanager]
    end
    
    F --> J
```

## Components

| Directory | Purpose |
|-----------|---------|
| `infrastructure/terraform/` | GKE cluster provisioning (GCP) |
| `kubernetes/` | Base + overlay manifests (Kustomize) |
| `istio/` | Gateway, VirtualServices, canary routing |
| `monitoring/` | Prometheus rules, Grafana dashboards, alerts |
| `scripts/` | Deploy, canary promote, rollback utilities |
| `release/` | CI/CD pipeline templates |

## Quick Start

```bash
# Provision GKE cluster
cd infrastructure/terraform
terraform init && terraform apply -var="project_id=my-project"

# Deploy to dev
./scripts/deploy.sh dev

# Promote canary to stable
./scripts/canary-promote.sh
```

## Tech Stack

- **Cloud**: GCP (GKE), also applicable to AWS EKS / Azure AKS
- **IaC**: Terraform for cluster provisioning
- **Service Mesh**: Istio — traffic management, canary routing, mTLS
- **Observability**: Prometheus + Grafana + Alertmanager
- **Deployment**: Kustomize overlays + Argo CD GitOps
- **Scripting**: Bash for operational tooling

## Author

**Jai Gogineni** — [jaigogineni.com](https://jaigogineni.com)
