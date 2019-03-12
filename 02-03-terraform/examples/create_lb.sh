#!/usr/bin/env bash

echo "creating lb config"
YC_FOLDER_ID=$(terraform output folder_id | tr  -d "\"")

TARGET_GROUP_ID=$(curl -X GET  --silent -H "Authorization: Bearer $(yc iam create-token)"  \
 -H "Content-Type: application/json" \
 -k "https://load-balancer.api.cloud.yandex.net/load-balancer/v1alpha/targetGroups?folderId=${YC_FOLDER_ID}"  | jq .targetGroups[0].id | tr -d "\"")

cat > create-lb.json <<EOF
{
    "folderId": "${YC_FOLDER_ID}",
    "name": "yc-auto-lb",
    "regionId": "ru-central1",
    "type": "EXTERNAL",
    "listenerSpecs": [
      {
        "port": "80",
        "protocol": "TCP",
        "externalAddressSpec": {
          "address": "",
          "ipVersion": "IPV4",
          "regionId": "ru-central1"
      }
      }
    ],
    "attachedTargetGroups": [
    {
      "targetGroupId": "${TARGET_GROUP_ID}",
      "healthChecks": [
        {
          "name": "http",
          "interval": "2s",
          "timeout": "1s",
          "unhealthyThreshold": "2",
          "healthyThreshold": "2",
          "httpOptions": {
            "port": "80",
            "path": "/"
          },
        }
      ]
    }
  ]

}
EOF


curl -X POST \
  -H "Authorization: Bearer $(yc iam create-token)" \
	-H "Content-Type: application/json" \
	-k "https://load-balancer.api.cloud.yandex.net/load-balancer/v1alpha/networkLoadBalancers" \
  -d @create-lb.json
