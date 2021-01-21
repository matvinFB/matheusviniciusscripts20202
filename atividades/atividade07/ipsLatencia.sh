#!/bin/bash

echo "Relatório de Latência."

for i in $(cat $1)
do
	echo $i $(ping -c 1 -w 5 8.8.8.8 | tail -1 | cut -d "/" -f 5)"ms"
done
