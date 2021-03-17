#!/bin/bash

apt-get update
apt-get install apache2 -y

cat << EOF > /usr/local/bin/checaSistema.sh
#!/bin/bash


	DATA=\$(date +%H:%M:%S-%D)
	execT=\$(uptime -p | sed 's/up//g')
	loadB=\$(uptime | sed 's/load average:/!/g' | cut -d "!" -f 2)
	qtdML=\$(free -m | sed -n '2p'| awk '{print \$4}')
	qtdMU=\$(free -m | sed -n '2p'| awk '{print \$3}')
	byteO=\$(grep -n "eth0" /proc/net/dev | awk '{print \$10}')
	byteI=\$(grep -n "eth0" /proc/net/dev | awk '{print \$3}')
	
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

footer {
	display: flex;
	justify-content: center;
	padding: 5px;
	
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
    <td>Data da leitura</td>
    <td>\$DATA</td>
  </tr>
  <tr>
    <td>Tempo Ativo</td>
    <td>\$execT</td>
  </tr>
  <tr>
    <td>Carga Media</td>
    <td>\$loadB</td>
  </tr>
  <tr>
    <td>Memoria Livre</td>
    <td>\$qtdML</td>
  </tr>
  <tr>
    <td>Memoria em Uso</td>
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

<footer><small><i>Feito por</i> <b>Hehehe</b></small><footer>
</body>
</html>


hehehe
	


EOF
chmod 744 /usr/local/bin/checaSistema.sh

./usr/local/bin/checaSistema.sh

(crontab -l 2>/dev/null; echo "* * * * * /usr/local/bin/checaSistema.sh")| crontab -u root -





