#!/bin/bash

echo "🧪 Checking FastAPI Ingress Setup..."

echo "🔍 Checking Ingress..."
kubectl get ingress

echo "🔍 Describing Ingress routing..."
kubectl describe ingress fastapi-ingress | grep -A5 "Rules"

echo "🔍 Checking Service..."
kubectl get svc python-api

echo "🔍 Describing Service routing..."
kubectl describe svc python-api | grep -E "Selector:|Port:|TargetPort:"

echo "🔍 Checking Pods with label 'app=python-api'..."
kubectl get pods -l app=python-api

POD_NAME=$(kubectl get pods -l app=python-api -o jsonpath="{.items[0].metadata.name}")
echo "📄 Logs from FastAPI pod: $POD_NAME"
kubectl logs "$POD_NAME" --tail=10

echo "🔍 Checking Ingress Controller pods (namespace: ingress-nginx)..."
kubectl get pods -n ingress-nginx

# Extract path from Ingress
PATH_PREFIX=$(kubectl get ingress fastapi-ingress -o jsonpath='{.spec.rules[0].http.paths[0].path}')
[[ "$PATH_PREFIX" == "/" ]] && PREFIX="" || PREFIX="$PATH_PREFIX"

# Test POST to /set
echo "🌐 Testing POST endpoint with curl: http://localhost$PREFIX/set?key=test&value=ok"
curl -i -X POST "http://localhost$PREFIX/set?key=test&value=ok"

# Test GET from /get
echo ""
echo "🌐 Testing GET endpoint with curl: http://localhost$PREFIX/get?key=test"
curl -i "http://localhost$PREFIX/get?key=test"

echo ""
echo "✅ Done!"
