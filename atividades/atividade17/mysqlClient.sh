#!/bin/bash

apt-get update
apt-get install mysql-client -y



echo "[client]" >> /home/ubuntu/.my.cnf
echo "user=user" >> /home/ubuntu/.my.cnf
echo "password=user123" >> /home/ubuntu/.my.cnf

mysql -u user scripts -h MUDAR << EOF

CREATE TABLE Teste ( atividade INT );
quit
EOF

