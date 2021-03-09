#!/bin/bash
# Correção: 2,5. Não cria o arquivo dirSensors.log

numArq=$(ls $2 | wc -l)

rm temp 2>/dev/null
rm temp2 2>/dev/null

ls $2 >> temp

while true
do
	numAtual=$(ls $2 | wc -l)
	if [ $numArq -lt $numAtual ]
	then
		now=$(date +"%d-%m-%Y %H:%M:%S")
		ls $2 >> temp2
		echo -ne [$now] "Alteração! $numArq->$numAtual. Adicionados: "
		tam=$(grep -Fxv -f temp temp2|wc -l)
		
		for i in $(grep -Fxv -f temp temp2)
		do
			echo -ne "$i"
			if [ $tam -gt 1 ]
			then
				echo -ne ", "
			fi
			tam=$((tam-1))
		done

		mv temp2 temp
		
		echo	
	
	elif [ $numArq -gt $numAtual ]
	then
		now=$(date +"%d-%m-%Y %H:%M:%S")
		ls $2 >> temp2
		echo -ne [$now] "Alteração! $numArq->$numAtual. Removidos: "
		tam=$(grep -Fxv -f temp2 temp|wc -l)
                for i in $(grep -Fxv -f temp2 temp)
                do
                        echo -ne "$i"
                        if [ $tam -gt 1 ]
                        then
                                echo -ne ", "
                        fi
                        
                        tam=$((tam-1))
                done
		
		mv temp2 temp

		echo	
	fi
	numArq=$numAtual
	sleep $1
done

