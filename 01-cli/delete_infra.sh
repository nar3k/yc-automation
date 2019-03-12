#usr/bin/env bash

zones=(a b c)


for i in ${!zones[@]}; do
  yc compute instance delete --name yc-auto-instance-$i
done



for i in ${!zones[@]}; do
  yc vpc subnet delete --name yc-auto-subnet-$i 
done


yc vpc network delete --name yc-auto-network
