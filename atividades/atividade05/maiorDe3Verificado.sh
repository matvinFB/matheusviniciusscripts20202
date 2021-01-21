#!/bin/bash
# Correção: 1,0

echo "$1 $2 $3"

if ! [ "$1" -eq "$1" ] 2> /dev/null
then
	echo "$1 não é um número"
elif ! [ $2 -eq $2 ] 2> /dev/null
then
	echo "$2 não é um número"
elif ! [ $3 -eq $3 ] 2> /dev/null
then
	echo "$3 não é um número"
elif [ $1 -gt $2 ]
then
	[ $1 -gt $3 ] && echo "$1" || echo "$3"
else
	[ $2 -gt $3 ] && echo "$2" || echo "$3"
fi
