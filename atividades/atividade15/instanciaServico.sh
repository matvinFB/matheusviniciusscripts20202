#!/bin/bash

echo "Criando servidor de Monitoramento..."
grupo=$(aws ec2 create-security-group --group-name serverhttp --description "grupo para o server http" --output text)

aws ec2 authorize-security-group-ingress --group-id $grupo --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress --group-id $grupo --protocol tcp --port 80 --cidr 0.0.0.0/0

subrede=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)

id=$(aws ec2 run-instances --image-id ami-042e8287309f5df03 --instance-type t2.micro --key-name $1 --security-group-ids $grupo --subnet-id $subrede --user-data file://webserver.sh --query "Instances[0].InstanceId" --output text)

sleep 10
state=$(aws ec2 describe-instance-status --instance-ids $id --query "InstanceStatuses[].SystemStatus.Details[].Status" --output text)

until [ "$state" != "passed" ]
do
state=$(aws ec2 describe-instance-status --instance-ids $id --query "InstanceStatuses[].SystemStatus.Details[].Status" --output text)
done

publicIp=$(aws ec2 describe-instances --instance-id $id --query "Reservations[].Instances[].NetworkInterfaces[].Association[].PublicIp" --output text)

echo "Acesse: $publicIp"
