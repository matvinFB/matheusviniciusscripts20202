#!/bin/bash

sudo apt update
sudo apt install apache2 -y

cat << EOF > /usr/local/bin/checaSistema.sh
#!/bin/bash

while true
do
	DATA=$(date +%H:%M:%S-%D)
	execT=$(uptime -p | sed 's/up//g')
	loadB=$(uptime | sed 's/user,  /!/g' | cut -d "!" -f 2)
	qtdML=$(free -m | sed -n '2p'| awk '{print $4}')
	qtdMU=$(free -m | sed -n '2p'| awk '{print $3}')
	byteO=$(grep -n "eth0" /proc/net/dev | awk '{print $10}')
	byteI=$(grep -n "eth0" /proc/net/dev | awk '{print $3}')
	
cat << hehehe >  /var/www/html/index.html
<!DOCTYPE html>
<!DOCTYPE html>
<html>
<head>
<style>
table {
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}

tr:nth-child(even) {
  background-color: #dddddd;
}
</style>
</head>
<body>

<h2>Dados do Sistema</h2>

<table>
  <tr>
    <th>Dado</th>
    <th>Valor</th>
  </tr>
  <tr>
    <td>Data</td>
    <td>\$DATA</td>
  </tr>
  <tr>
    <td>Tempo Ativo</td>
    <td>\$execT</td>
  </tr>
  <tr>
    <td>Carga Média</td>
    <td>\$loadB</td>
  </tr>
  <tr>
    <td>Memória Livre</td>
    <td>\$qtdML</td>
  </tr>
  <tr>
    <td>Memória em Uso</td>
    <td>\$qtdMU</td>
  </tr>  
  <tr>
    <td>Bytes Recebidos</td>
    <td>\$byteO</td>
  </tr>
  <tr>
    <td>Bytes Enviados</td>
    <td>\$byteI</td>
  </tr>
</table>

</body>
</html>


hehehe
	
	
	sleep 5
done

EOF

cat << EOF > /etc/systemd/system/chegagemDoSistema.service
[Unit]
After=network.target

[Service]
ExecStart=/usr/local/bin/checaSistema.sh

[Install]
WantedBy=default.target
EOF

sudo chmod 664 /etc/systemd/system/chegagemDoSistema.service
sudo systemctl daemon-reload
sudo systemctl start /etc/systemd/system/chegagemDoSistema.service
sudo systemctl enable chegagemDoSistema.service






