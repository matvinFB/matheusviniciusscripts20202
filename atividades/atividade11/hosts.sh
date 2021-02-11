#!/bin/bash

rem=0
add=0
lis=0
host=
ip=

while getopts "a:i:d:l" var
do
	case "$var" in
		a)
			add=1
			host=${OPTARG}
			;;
		i) ip=${OPTARG} ;;
		d)
			rem=1
			host=${OPTARG}
			;;
		l) lis=1 ;;
		\?) ;;
	esac
	
done

if [ "$add" = "1" ]
then
	echo "($host,$ip)" >> hosts.db
elif [ "$rem" = "1" ]
then
	sed -i "/$host/d" ./hosts.db
elif [ "$lis" = "1" ]
then
	while read linha
	do
		linha=$( echo $linha | sed 's/(//' )
		linha=$( echo $linha | sed 's/)//' )
		echo $( echo $linha | cut -d "," -f1 ) "     " $( echo $linha | cut -d "," -f2 )
	done <hosts.db

else

	linha=$(grep $1 ./hosts.db)
	linha=$( echo $linha | sed 's/(//' )
	linha=$( echo $linha | sed 's/)//' )
	echo $( echo $linha | cut -d "," -f1 ) "     " $( echo $linha | cut -d "," -f2 )
fi 

