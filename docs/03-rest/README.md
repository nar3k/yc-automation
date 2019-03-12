# REST API

## Создаем таргет группу с риалами ( ./examples/create_tg.sh )

Создадим таргет группу -

```
YC_FOLDER_ID=$(terraform output folder_id | tr  -d "\"")

cat > create-tg.json <<EOF
{
    "folderId": "${YC_FOLDER_ID}",
    "name": "yc-auto-tg",
    "regionId": "ru-central1"
}
EOF


curl -X POST \
  -H "Authorization: Bearer $(yc iam create-token)" \
	-H "Content-Type: application/json" \
	-k "https://load-balancer.api.cloud.yandex.net/load-balancer/v1alpha/targetGroups" \
  -d @create-tg.json

rm -rf create-tg.json
```

Подключим к таргет группе созданные через terraform веб сервера

```

TARGET_GROUP_ID=$(curl -X GET  --silent -H "Authorization: Bearer $(yc iam create-token)"  \
 -H "Content-Type: application/json" \
 -k "https://load-balancer.api.cloud.yandex.net/load-balancer/v1alpha/targetGroups?folderId=${YC_FOLDER_ID}"  | jq .targetGroups[0].id | tr -d "\"")

SUBNET_ID_LIST=$(terraform output subnet_ids)
SUBNET_ID_LIST=($(echo "$SUBNET_ID_LIST" | tr ',' '\n'))
INTERNAL_ADDRESS_LIST=$(terraform output internal_ip_addresses)
INTERNAL_ADDRESS_LIST=($(echo "$INTERNAL_ADDRESS_LIST" | tr ',' '\n'))



for i in ${!INTERNAL_ADDRESS_LIST[@]}; do

  SUBNET_ID=${SUBNET_ID_LIST[$i]}
  INTERNAL_ADDRESS=${INTERNAL_ADDRESS_LIST[$i]}
  echo "adding  $INTERNAL_ADDRESS to target group"
  cat > add_real.json <<EOF
  {
    "targets":
    [
      {
        "subnetId": "${SUBNET_ID}",
        "address": "${INTERNAL_ADDRESS}"
      }
    ]
  }
EOF

  curl -X POST \
    -H "Authorization: Bearer $(yc iam create-token)" \
  	-H "Content-Type: application/json" \
    -k https://load-balancer.api.cloud.yandex.net/load-balancer/v1alpha/targetGroups/${TARGET_GROUP_ID}:addTargets \
    -d @add_real.json

  sleep 2
done

rm -rf add_real.json.json
```

### Создадим балансировщик (./examples/create_lb.sh )


```
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
```
### Проверим балансировщик (./examples/check_lb.sh )

```
echo "checking lb config"


EXTERNAL_IP=$(curl -X GET --silent  -H "Authorization: Bearer $(yc iam create-token)"   \
  -k "https://load-balancer.api.cloud.yandex.net/load-balancer/v1alpha/networkLoadBalancers?folderId=${YC_FOLDER_ID}"  \
  | jq .networkLoadBalancers[0].listeners[0].address  |  tr -d "\"")

for i in {1..30}
do
  curl --silent $EXTERNAL_IP
done
```


Переходим на следующее задание [Удаление инфраструктуры](../04-delete/README.md)
