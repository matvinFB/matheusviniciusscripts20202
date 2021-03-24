#!/bin/bash
# Correção: 0,8

echo "Criando servidor do Banco de Dados..."
grupo=$(aws ec2 create-security-group --group-name mysqlserver --description "grupo para o server mysql" --output text)

meuIP=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | sed 's/\"//g')"/32"

aws ec2 authorize-security-group-ingress --group-id $grupo --protocol tcp --port 22 --cidr $meuIP

aws ec2 authorize-security-group-ingress --group-id $grupo --protocol tcp --port 80 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress --group-id $grupo --protocol tcp --port 3306 --source-group $grupo

subrede=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)

id=$(aws ec2 run-instances --image-id ami-042e8287309f5df03 --instance-type t2.micro --key-name $1 --security-group-ids $grupo --subnet-id $subrede --user-data file://mysqlServer.sh --query "Instances[0].InstanceId" --output text)

state=$(aws ec2 describe-instances --query "Reservations[].Instances[].State.Name" --output text)


while [ "$state" != "running" ]
do
state=$(aws ec2 describe-instances --instance-id $id --query "Reservations[].Instances[].State.Name" --output text)
done

ipPrivado=$(aws ec2 describe-instances --instance-id $id --query "Reservations[].Instances[].PrivateIpAddress" --output text)


until [ "$ipPrivado" != "none" ]
do
ipPrivado=$(aws ec2 describe-instances --instance-id $id --query "Reservations[].Instances[].PrivateIpAddress" --output text)
done


echo "IP Privado do Banco de dados: $ipPrivado"



#INSERE O IP PRIVADO DA MAQUINA 1 NO SCRIPT DE INICIALIZACAO DA MAQUINA 2
sed -i "s/MUDAR/$ipPrivado/" ./mysqlClient.sh

echo "Criando servidor de Aplicação..."

id2=$(aws ec2 run-instances --image-id ami-042e8287309f5df03 --instance-type t2.micro --key-name $1 --security-group-ids $grupo --subnet-id $subrede --user-data file://mysqlClient.sh --query "Instances[0].InstanceId" --output text)

ipPublico=$(aws ec2 describe-instances --instance-id $id2 --query "Reservations[].Instances[].NetworkInterfaces[].Association[].PublicIp" --output text)

#GARANTE QUE O IP PUBLICO DA SEGUNDA INSTANCIA JA FOI ATRIBUIDO
until [ "$ipPublico" != "" ]
do
ipPublico=$(aws ec2 describe-instances --instance-id $id2 --query "Reservations[].Instances[].NetworkInterfaces[].Association[].PublicIp" --output text)
done

#RESTAURA O SCRIPT DE INICIALIZACAO DA MAQUINA 2
sed -i "s/$ipPrivado/MUDAR/" ./mysqlClient.sh

echo "IP Publico do Servidor de Aplicação: $ipPublico"







