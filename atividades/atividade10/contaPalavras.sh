#!/bin/bash
# Correção: 2,0


printf "Informe o arquivo: "
read arq

tr ' ' '\n' <$arq >tempt.txt
awk 'NF' tempt.txt >temptt.txt
tr -d '“\056\077\072\054\042\133\135\134' <temptt.txt >temp.txt
rm tempt.txt
rm temptt.txt

#cat temp.txt


for i in $(sort -u temp.txt | cut -d " " -f2)
do
	echo "$i : $(grep -w $i temp.txt | wc -l)"
done

rm temp.txt

