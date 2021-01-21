#!/bin/bash
# Correção: 1,0

#Professor, possivelmente espera que eu use 3 IF para verificar a existencia das pastas. Entretanto decide escrever assim pois é mais simples e faz uso dos recursos já implementados na linguagem.
for i in $(ls $1)
do
	dataarq=$( date -r $1/$i "+%Y/%m/%d" )
	ano=$(echo $dataarq | cut -d "/" -f 1)
	mes=$(echo $dataarq | cut -d "/" -f 2)
	dia=$(echo $dataarq | cut -d "/" -f 3)

	mkdir $2$ano 2> /dev/null
	mkdir $2$ano/$mes 2> /dev/null
	mkdir $2$ano/$mes/$dia 2> /dev/null 
		
	cp "$1/$i"  "$2/$dataarq/"
done

