#!/bin/bash

read -p "Enter the key: " key
read -p "Enter the value: " value

# base_url="http://localhost/api"

# POST
#curl -X POST "http://localhost/set?key=$key&value=$value"
curl -X POST "http://localhost/api/set?key=$key&value=$value"


# GET
echo ""
echo "Retrieving key..."
#curl "http://localhost/get?key=$key"
curl "http://localhost/api/get?key=$key"
echo
