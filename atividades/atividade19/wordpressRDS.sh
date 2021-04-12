#!/bin/bash
# Correção: 0,0. Mas presença computada.RKVz720$tqjHiJVO9Q
echo "Criando servidor do Banco de Dados..."


vpcid=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query "Vpc.VpcId" --output text)

gatewayId=$(aws ec2 create-internet-gateway --query "InternetGateway.InternetGatewayId" --output text)

aws ec2 attach-internet-gateway --internet-gateway-id $gatewayId --vpc-id $vpcid > /dev/null

routeTable=$(aws ec2 describe-route-tables --filters Name=vpc-id,Values=$vpcid --query "RouteTables[].Associations[].RouteTableId" --output text)

aws ec2 create-route --route-table-id $routeTable --destination-cidr-block 0.0.0.0/0 --gateway-id $gatewayId > /dev/null


subA=$(aws ec2 create-subnet --vpc-id $vpcid --cidr-block 10.0.1.0/24 --availability-zone us-east-1a --query "Subnet.SubnetId" --output text)
subB=$(aws ec2 create-subnet --vpc-id $vpcid --cidr-block 10.0.2.0/24 --availability-zone us-east-1b --query "Subnet.SubnetId" --output text)
subC=$(aws ec2 create-subnet --vpc-id $vpcid --cidr-block 10.0.3.0/24 --availability-zone us-east-1c --query "Subnet.SubnetId" --output text)
subD=$(aws ec2 create-subnet --vpc-id $vpcid --cidr-block 10.0.4.0/24 --availability-zone us-east-1d --query "Subnet.SubnetId" --output text)

aws ec2 modify-subnet-attribute --subnet-id $subA --map-public-ip-on-launch
aws ec2 modify-subnet-attribute --subnet-id $subB --map-public-ip-on-launch
aws ec2 modify-subnet-attribute --subnet-id $subC --map-public-ip-on-launch
aws ec2 modify-subnet-attribute --subnet-id $subD --map-public-ip-on-launch

subgrupo=$(aws rds create-db-subnet-group --db-subnet-group-name "MySQL" --db-subnet-group-description "grupo do BD mysql do wordpress" --subnet-id $subA $subB $subC $subD --query "DBSubnetGroup.DBSubnetGroupName" --output text)

grupo=$(aws ec2 create-security-group --group-name mysqlserver --description "grupo para o server mysql" --vpc-id $vpcid --output text )

meuIP=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | sed 's/\"//g')"/32"

aws ec2 authorize-security-group-ingress --group-id $grupo --protocol tcp --port 22 --cidr $meuIP

aws ec2 authorize-security-group-ingress --group-id $grupo --protocol tcp --port 80 --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress --group-id $grupo --protocol tcp --port 3306 --source-group $grupo

aws rds create-db-instance \
--db-name scripts \
--db-instance-identifier scripts \
--allocated-storage 20 \
--db-instance-class db.t2.micro \
--engine mysql \
--vpc-security-group-ids $grupo \
--db-subnet-group-name $subgrupo \
--master-username $2 \
--master-user-password $3 \
--no-publicly-accessible > /dev/null
 
statusDB=$(aws rds describe-db-instances --query "DBInstances[].DBInstanceStatus" --output text)

#DEMORA MUITO, NAO PRECISA COMECAR A TESTAR COM TAO CEDO
sleep 60

#GARANTE QUE O DB ESTA ON
while [ "$statusDB" = "creating" ]
do
statusDB=$(aws rds describe-db-instances --query "DBInstances[].DBInstanceStatus" --output text)
done

address=$(aws rds describe-db-instances --query "DBInstances[].Endpoint[].Address" --output text)

#INSERE O IP PRIVADO DA MAQUINA 1 NO SCRIPT DE INICIALIZACAO DA MAQUINA 2
#INSERE O USUARIO DADO POR $2 E A SENHA $3 NO SCRIPT DO CLIENTE
sed -i "s/MUDARUSER/$2/" ./mysqlClient.sh
sed -i "s/MUDARSENHA/$3/" ./mysqlClient.sh
sed -i "s/MUDAR/$address/" ./mysqlClient.sh

sleep 30

echo "Criando servidor de Aplicação..."

#INSTANCIA A MAQUINA 2 USANDO O SCRIPT mysqlClient.sh
id2=$(aws ec2 run-instances --image-id ami-042e8287309f5df03 --instance-type t2.micro --key-name $1 --security-group-ids $grupo --subnet-id $subD --user-data file://mysqlClient.sh --query "Instances[0].InstanceId" --output text)

ipPublico=$(aws ec2 describe-instances --instance-id $id2 --query "Reservations[].Instances[].NetworkInterfaces[].Association[].PublicIp" --output text)

#GARANTE QUE O IP PUBLICO DA SEGUNDA INSTANCIA JA FOI ATRIBUIDO
until [ "$ipPublico" != "" ]
do
ipPublico=$(aws ec2 describe-instances --instance-id $id2 --query "Reservations[].Instances[].NetworkInterfaces[].Association[].PublicIp" --output text)
done

#RESTAURA O SCRIPT DE INICIALIZACAO DA MAQUINA 2
sed -i "s/$address/MUDAR/" ./mysqlClient.sh
sed -i "s/$3/MUDARSENHA/" ./mysqlClient.sh
sed -i "s/$2/MUDARUSER/" ./mysqlClient.sh

echo ""

echo "IP Publico do Servidor de Aplicação: $ipPublico"

echo ""

echo "Acesse http://$ipPublico/wordpress para finalizar a configuração."
echo "O site pode levar mais algunas intastes para se colocado no ar, por favor aguarde"







