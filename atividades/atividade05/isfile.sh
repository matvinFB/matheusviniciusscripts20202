#!/bin/bash

[ -f $1 ] && echo "É um arquivo." 
[ -d $1 ] && echo "É um diretório."
[ -r $1 ] && echo "Tem permissão de leitura." || echo "Não tem permissão de leitura."
[ -w $1 ] && echo "Tem permissão de escrita" || echo "Não tem permissão de escrita"
