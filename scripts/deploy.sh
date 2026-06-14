#!/bin/bash
set -euo pipefail
ENV=${1:-dev}
echo "Deploying to $ENV..."
kubectl apply -k kubernetes/overlays/$ENV
kubectl rollout status deployment/platform-service -n platform-$ENV --timeout=300s
echo "Deploy complete. Running health check..."
kubectl exec -it deploy/platform-service -- curl -sf http://localhost:8080/health
