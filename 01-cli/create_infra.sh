#usr/bin/env bash
echo "Creating network yc-auto-network"
yc vpc network create --name yc-auto-network

zones=(a b c)

for i in ${!zones[@]}; do
  echo "Creating subnet yc-auto-subnet-$i"
  yc vpc subnet create --name yc-auto-subnet-$i \
  --zone ru-central1-${zones[$i]} \
  --range 192.168.$i.0/24 \
  --network-name yc-auto-network
done


for i in ${!zones[@]}; do
  echo "Creating instance yc-auto-instance-$i"
  yc compute instance create --name yc-auto-instance-$i \
  --hostname yc-auto-instance-$i \
  --zone ru-central1-${zones[$i]} --metadata-from-file user-data=./metadata.yaml \
  --create-boot-disk image-family=ubuntu-1804-lts,size=30,type=network-nvme \
  --image-folder-id standard-images \
  --memory 4 --cores 2 --core-fraction 100 \
  --network-interface subnet-name=yc-auto-subnet-$i,nat-ip-version=ipv4  --async
done
