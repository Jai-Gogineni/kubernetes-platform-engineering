#!/bin/bash
set -euo pipefail
echo "Promoting canary to stable..."
kubectl patch virtualservice platform-service-canary --type=merge \
  -p '{"spec":{"http":[{"route":[{"destination":{"host":"platform-service","subset":"stable"},"weight":100}]}]}}'
echo "Canary promoted. 100% traffic on stable."
