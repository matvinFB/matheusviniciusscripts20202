#!/bin/bash
# Correção: 2,5 

echo "Criando servidor do Banco de Dados..."
grupo=$(aws ec2 create-security-group --group-name mysqlserver --description "grupo para o server mysql" --output text)

meuIP=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | sed 's/\"//g')"/32"

aws ec2 authorize-security-group-ingress --group-id $grupo --protocol tcp --port 22 --cidr $meuIP

aws ec2 authorize-security-group-ingress --group-id $grupo --protocol tcp --port 80 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress --group-id $grupo --protocol tcp --port 3306 --source-group $grupo

subrede=$(aws ec2 describe-subnets --query "Subnets[0].SubnetId" --output text)



#INSERE O USUARIO DADO POR $2 E A SENHA $3 NO SCRIPT DO SERVIDOR
sed -i "s/MUDARUSER/$2/" ./mysqlServer.sh
sed -i "s/MUDARSENHA/$3/" ./mysqlServer.sh


#INSTANCIA A MAQUINA 1 USANDO O SCRIPT mysqlServer.sh
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

#RESTAURA O SCRIPT DE INICIALIZACAO DA MAQUINA 1
sed -i "s/$2/MUDARUSER/" ./mysqlServer.sh
sed -i "s/$3/MUDARSENHA/" ./mysqlServer.sh

echo "IP Privado do Banco de dados: $ipPrivado"



#INSERE O IP PRIVADO DA MAQUINA 1 NO SCRIPT DE INICIALIZACAO DA MAQUINA 2
#INSERE O USUARIO DADO POR $2 E A SENHA $3 NO SCRIPT DO CLIENTE
sed -i "s/MUDARUSER/$2/" ./mysqlClient.sh
sed -i "s/MUDARSENHA/$3/" ./mysqlClient.sh
sed -i "s/MUDAR/$ipPrivado/" ./mysqlClient.sh


sleep 30

echo "Criando servidor de Aplicação..."

#INSTANCIA A MAQUINA 2 USANDO O SCRIPT mysqlClient.sh
id2=$(aws ec2 run-instances --image-id ami-042e8287309f5df03 --instance-type t2.micro --key-name $1 --security-group-ids $grupo --subnet-id $subrede --user-data file://mysqlClient.sh --query "Instances[0].InstanceId" --output text)

ipPublico=$(aws ec2 describe-instances --instance-id $id2 --query "Reservations[].Instances[].NetworkInterfaces[].Association[].PublicIp" --output text)

#GARANTE QUE O IP PUBLICO DA SEGUNDA INSTANCIA JA FOI ATRIBUIDO
until [ "$ipPublico" != "" ]
do
ipPublico=$(aws ec2 describe-instances --instance-id $id2 --query "Reservations[].Instances[].NetworkInterfaces[].Association[].PublicIp" --output text)
done

#RESTAURA O SCRIPT DE INICIALIZACAO DA MAQUINA 2
sed -i "s/$ipPrivado/MUDAR/" ./mysqlClient.sh
sed -i "s/$2/MUDARUSER/" ./mysqlClient.sh
sed -i "s/$3/MUDARSENHA/" ./mysqlClient.sh

echo "IP Publico do Servidor de Aplicação: $ipPublico"

echo ""

echo "Acesse http://$ipPublico/wordpress para finalizar a configuração"







