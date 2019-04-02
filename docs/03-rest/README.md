# REST API

## Создадим [Целевую группу](https://cloud.yandex.ru/docs/load-balancer/concepts/target-resources) с нашими инстансами ( ./examples/create_tg.sh )

Создадим целевую группу -

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
	-k "https://load-balancer.api.cloud.yandex.net/load-balancer/v1/targetGroups" \
  -d @create-tg.json

rm -rf create-tg.json
```

Подключим к целевой группу группе созданные через terraform веб сервера

```

TARGET_GROUP_ID=$(curl -X GET  --silent -H "Authorization: Bearer $(yc iam create-token)"  \
 -H "Content-Type: application/json" \
 -k "https://load-balancer.api.cloud.yandex.net/load-balancer/v1/targetGroups?folderId=${YC_FOLDER_ID}"  | jq .targetGroups[0].id | tr -d "\"")

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
    -k https://load-balancer.api.cloud.yandex.net/load-balancer/v1/targetGroups/${TARGET_GROUP_ID}:addTargets \
    -d @add_real.json

  sleep 2
done

rm -rf add_real.json.json
```

### Создадим [балансировщик](https://cloud.yandex.ru/docs/load-balancer/concepts/index) с целевой группой (./examples/create_lb.sh )


Создадим балансировщик
```
YC_FOLDER_ID=$(yc config get folder-id)

<<<<<<< HEAD
TARGET_GROUP_ID=$(curl -X GET  --silent -H "Authorization: Bearer $(yc iam create-token)"  \
 -H "Content-Type: application/json" \
 -k "https://load-balancer.api.cloud.yandex.net/load-balancer/v1/targetGroups?folderId=${YC_FOLDER_ID}"  | jq .targetGroups[0].id | tr -d "\"")
=======
>>>>>>> 4cbaaccf1c695ce33854b5f418b9f7c6c7e6b3cc

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
    ]
}
EOF



echo "Creating Load balancer"

curl -X POST \
  -H "Authorization: Bearer $(yc iam create-token)" \
	-H "Content-Type: application/json" \
	-k "https://load-balancer.api.cloud.yandex.net/load-balancer/v1/networkLoadBalancers" \
  -d @create-lb.json
rm -rf create-lb.json

sleep 15
```

Подключим к балансировщику целевую группу
```

LB_ID=$(curl -X GET  --silent -H "Authorization: Bearer $(yc iam create-token)"  \
 -H "Content-Type: application/json" \
 -k "https://load-balancer.api.cloud.yandex.net/load-balancer/v1/networkLoadBalancers?folderId=${YC_FOLDER_ID}"  | jq .networkLoadBalancers[0].id | tr -d "\"")

TARGET_GROUP_ID=$(curl -X GET  --silent -H "Authorization: Bearer $(yc iam create-token)"  \
 -H "Content-Type: application/json" \
 -k "https://load-balancer.api.cloud.yandex.net/load-balancer/v1/targetGroups?folderId=${YC_FOLDER_ID}"  | jq .targetGroups[0].id | tr -d "\"")



cat > attach-tg.json <<EOF
 {
     "attachedTargetGroup": {

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
            "path": "/index.html"
           },
         }
      ]
     }
}
EOF
echo "Attaching target group to  Load balacer"


curl -X POST \
  -H "Authorization: Bearer $(yc iam create-token)" \
	-H "Content-Type: application/json" \
<<<<<<< HEAD
	-k "https://load-balancer.api.cloud.yandex.net/load-balancer/v1/networkLoadBalancers" \
  -d @create-lb.json
=======
	-k "https://load-balancer.api.cloud.yandex.net/load-balancer/v1/networkLoadBalancers/${LB_ID}:attachTargetGroup" \
  -d @attach-tg.json


rm -rf attach-tg.json
>>>>>>> 4cbaaccf1c695ce33854b5f418b9f7c6c7e6b3cc
```


### Проверим балансировщик (./examples/check_lb.sh )

```
echo "checking load balancer "


EXTERNAL_IP=$(curl -X GET --silent  -H "Authorization: Bearer $(yc iam create-token)"   \
  -k "https://load-balancer.api.cloud.yandex.net/load-balancer/v1/networkLoadBalancers?folderId=${YC_FOLDER_ID}"  \
  | jq .networkLoadBalancers[0].listeners[0].address  |  tr -d "\"")

for i in {1..30}
do
  curl --silent $EXTERNAL_IP
done
```


Переходим на следующее задание [Удаление инфраструктуры](../04-delete/README.md)
