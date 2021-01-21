#!/bin/bash

data=$(date -d "$3" "+%Y%m%d%H%M%S")

for i in $(ls $1)
do
	dataarq=$( date -r $1/$i "+%Y%m%d%H%M%S" )

	if [[ $dataarq -gt $data  ]]
	then
		cp "$1/$i"  $2
	fi
	

done


