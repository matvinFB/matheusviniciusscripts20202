#!/bin/bash

apt-get update
apt-get install mysql-server -y


sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i "s/^mysqlx-bind-address.*/mysqlx-bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
systemctl restart mysql.service

mysql << EOF 
CREATE DATABASE scripts;
CREATE USER 'user'@'%' IDENTIFIED BY 'user123';
GRANT ALL PRIVILEGES ON scripts.* to 'user'@'%';
quit;
EOF

