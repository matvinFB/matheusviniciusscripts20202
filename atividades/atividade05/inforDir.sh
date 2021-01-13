#!/bin/bash

if [ -d $1 ]
then
	echo "O diretório $1 ocupa $(du -sh $1 2>/dev/null| cut -f1) e tem $(ls $1 | wc -l) itens."
else
	echo "$1 não é um diretório!"
fi
