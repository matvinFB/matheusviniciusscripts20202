#!/bin/bash
# Correção: 1,0

sed -i 's/#!\/bin\/python/\/usr\/bin\/python3/' atividade04.py
sed -i -r 's/nota1|nota2|notaFinal/\U&/g' atividade04.py
sed -i '3a \import  time' atividade04.py
sed -i '$a \   print time.ctime\(\)' atividade04.py

