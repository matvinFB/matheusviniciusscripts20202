# Correção: OK. 1,0 ponto. Apenas se acostume a colocar #!/bin/bash no início de cada script.
mkdir maiorque10
find ./ -size +10M -exec mv {} ./maiorque10/ \;
tar -czvf maiorque10.tar.gz maiorque10/
rm -r maiorque10
