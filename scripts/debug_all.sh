#!/bin/bash

# Configuration
HOST="localhost"
BASE_PATH="/api"
SET_PATH="$BASE_PATH/set"
GET_PATH="$BASE_PATH/get"
TEST_KEY="debug-key"
TEST_VALUE="debug-value"

echo "🔍 Step 1: Testing FastAPI Root Route"
curl -s "http://$HOST$BASE_PATH/" && echo ""

echo -e "\n🔄 Step 2: Setting key-value using POST /set"
curl -s -X POST "http://$HOST$SET_PATH?key=$TEST_KEY&value=$TEST_VALUE" && echo ""

echo -e "\n🔎 Step 3: Retrieving value using GET /get"
curl -s "http://$HOST$GET_PATH?key=$TEST_KEY" && echo ""

echo -e "\n🧪 Step 4: Checking Ingress Configuration"
kubectl get ingress fastapi-ingress -o yaml | grep -E 'host:|path:|rewrite|backend'

echo -e "\n📦 Step 5: Checking FastAPI logs for 404s"
kubectl logs -l app=python-api | tail -n 10

# Optional: Argo CD Status Check
read -p "🔐 Do you want to check Argo CD app status? (y/n): " check_argo

if [[ "$check_argo" == "y" ]]; then
    echo -e "\n🚦 Step 6: Argo CD App Status"
    kubectl get applications -n argocd
fi

echo -e "\n✅ Debug finished."
