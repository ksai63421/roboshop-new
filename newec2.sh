#!/bin/bash

NAMES=("mongodb" "reddis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "disptach" "web")
INSTANCE_TYPE=""
IMAGE_ID=ami-03265a0778a880afb
SECURITY_GROUP_ID=sg-0885f2e62d2bb3c88

# if mysql and mongodb is t3.medium and rest of them are t2.micro
for i in "${NAMES[@]}"
do
  if [[ $i == "mongodb" || $i == "mysql" ]];
  then 
      INSTANCE_TYPE="t3.medium"
     else
      INSTANCE_TYPE="t2.micro" 
    fi   
   echo "creating $i instance"

IP_ADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type t2.micro  --security-group-ids sg-0885f2e62d2bb3c88 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0], PrivateIpAddress')
echo "created $i instance: $IP_ADDRESS"
done