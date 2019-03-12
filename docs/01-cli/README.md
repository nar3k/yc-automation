# Работа через CLI

Переходим в папку `01-cli`

```
cd ./01-cli
```

### Создаем файл с метаданными

Подставьте в файл [metadata.yaml](/01-cli/metadata.yaml) свой публичный ssh ключ

###  Создаем инфраструктуру ( ./create_infra.sh )
Создадим сеть

```
yc vpc network create --name yc-auto-demo
```
Создадим 3 подсети

```
zones=(a b c)

for i in ${!zones[@]}; do
  yc vpc subnet create --name yc-auto-subnet-$i \
   --zone ru-central1-${zones[$i]} \
   --range 192.168.$i.0/24 \
   --network-name yc-auto-network
done
```
Создадим 3 Инстанса

```
for i in ${!zones[@]}; do
  yc compute instance create --name yc-auto-instance-$i \
  --hostname yc-auto-instance-$i \
  --zone ru-central1-${zones[$i]} --metadata-from-file user-data=./metadata.yaml \
  --create-boot-disk image-family=ubuntu-1804-lts,size=30,type=network-nvme \
  --image-folder-id standard-images \
  --memory 1 --cores 1 --core-fraction 100 \
  --network-interface subnet-name=yc-auto-subnet-$i,nat-ip-version=ipv4 --async
done
```
### Проверяем инфраструктуру


Подождем несколько минут, пока на ВМ установится nginx.
Чтобы убедится, что он установился, выполните
```
yc compute instance get-serial-port-output --name yc-auto-instance-1
```
И вы дожны увидеть похожий результат

```
-----END SSH HOST KEY KEYS-----
[  112.422383] cloud-init[547]: Cloud-init v. 18.3-9-g2e62cb8a-0ubuntu1~18.04.2 running 'modules:final' at Tue, 12 Mar 2019 13:40:27 +0000. Up 60.86 seconds.
[  112.425032] cloud-init[547]: Cloud-init v. 18.3-9-g2e62cb8a-0ubuntu1~18.04.2 finished at Tue, 12 Mar 2019 13:41:18 +0000. Datasource DataSourceEc2.  Up 112.41 seconds
[  OK  ] Started Execute cloud user/final scripts.
[  OK  ] Reached target Cloud-init target.
         Starting Daily apt download activities...
[  OK  ] Started Daily apt download activities.
         Starting Daily apt upgrade and clean activities...
[  OK  ] Started Daily apt upgrade and clean activities.
```

Далее узнаем адреса Инстансов
```

yc compute instance list --format json | jq .[].network_interfaces[0].primary_v4_address.one_to_one_nat.address
```
И попробуем сделать в них http запрос

```
for i in $(yc compute instance list --format json | jq .[].network_interfaces[0].primary_v4_address.one_to_one_nat.address | tr -d '"'); do  
 curl $i;
done
```
И установить ssh-соединение
```
ssh -i <путь до вашего ключа> ubuntu@<IP OF Instances>
```

###  Удаляем delete_infra.sh инфраструктуру ( ./delete_infra.sh )

Удаляем Инстансы

```
for i in ${!zones[@]}; do
  yc compute instance delete --name yc-auto-instance-$i --async
done
```

Удаляем Подсети
```
for i in ${!zones[@]}; do
  yc vpc subnet delete --name yc-auto-subnet-$i
done
```

Удаляем Сеть
```
yc vpc network delete --name yc-auto-network
```

Переходим на следующее задание [terraform](../02-terraform/README.md)
