mkdir maiorque10
find ./ -size +10M -exec mv {} ./maiorque10/ \;
tar -czvf maiorque10.tar.gz maiorque10/
rm -r maiorque10
