#usr/bin/env bash

zones=(a b c)


for i in ${!zones[@]}; do
  echo "Deleting instance yc-auto-instance-$i"
  yc compute instance delete --name yc-auto-instance-$i
done




for i in ${!zones[@]}; do
  echo "Deleting subnet yc-auto-subnet-$i"
  yc vpc subnet delete --name yc-auto-subnet-$i
done

echo "Deleting network yc-auto-network"
yc vpc network delete --name yc-auto-network
