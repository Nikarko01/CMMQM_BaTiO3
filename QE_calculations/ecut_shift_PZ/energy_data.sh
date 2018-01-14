#!/usr/bin/bash

echo -e 'ecut\tenergy(Ry)' > energy.dat

for file in *pwo
do
title="${file%.*}"
title="${title#*ec_}"
echo -n $title >> energy.dat
echo -en '\t' >> energy.dat
grep 'End of self-consistent calculation' -A 200 $file | grep 'total energy' | grep 'Ry' | awk '{print $5}' | tr '\n' ' '>> energy.dat
echo -e >> energy.dat
done

echo -e >> energy.dat