#!/bin/bash


grupo=$(aws ec2 create-security-group --group-name serverhttp --description "grupo para o server http" --output text)

aws ec2 authorize-security-group-ingress --group-id $grupo --protocol tcp --port 22 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress --group-id $grupo --protocol tcp --port 80 --cidr 0.0.0.0/0


aws ec2 run-instances --image-id ami-042e8287309f5df03 --instance-type t2.micro --key-name $1 --security-group-ids $grupo --subnet-id subnet-fbe78db6 --user-data file://webserver.sh

