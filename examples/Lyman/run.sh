#!/bin/bash
# Author     | Shuhei Ohno
# Licence    | CC-BY-4.0
# Repository | https://github.com/ohno/gaussian
# Comments   | run on WSL(Ubuntu)

#!/bin/bash

# input
mkdir CIS

for basis in "3-21G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31+G" "6-31+G(d)" "6-31+G(d,p)" "6-31++G" "6-31++G(d)" "6-31++G(d,p)" "6-311G" "6-311G(d)" "6-311G(d,p)" "6-311G(3d2f,3p2d)" "6-311+G" "6-311+G(d)" "6-311+G(d,p)" "6-311+G(3d2f,3p2d)" "6-311++G" "6-311++G(d)" "6-311++G(d,p)" "6-311++G(3d2f,3p2d)" "cc-pVDZ" "cc-pVTZ" "cc-pVQZ" "cc-pV5Z" "cc-pV6Z" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ" "aug-cc-pV5Z" "aug-cc-pV6Z"; do

echo "# CIS/$basis

Lyman series

0  2
H  0.0  0.0  0.0


" > "CIS/${basis}.gjf"

done

# run
folder=$(cd $(dirname $0); pwd)
bash ../g16.sh $folder/CIS

# grep
echo "" > results.csv
echo ",HF/" >> results.csv
for basis in "3-21G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31+G" "6-31+G(d)" "6-31+G(d,p)" "6-31++G" "6-31++G(d)" "6-31++G(d,p)" "6-311G" "6-311G(d)" "6-311G(d,p)" "6-311G(3d2f,3p2d)" "6-311+G" "6-311+G(d)" "6-311+G(d,p)" "6-311+G(3d2f,3p2d)" "6-311++G" "6-311++G(d)" "6-311++G(d,p)" "6-311++G(3d2f,3p2d)" "cc-pVDZ" "cc-pVTZ" "cc-pVQZ" "cc-pV5Z" "cc-pV6Z" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ" "aug-cc-pV5Z" "aug-cc-pV6Z"; do
  echo -n $basis | sed -e 's/,/_/g' >> results.csv
  echo -n "," >> results.csv
  grep -oP "(?<=SCF Done:  E\(UHF\) = )\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+)" CIS/${basis}.out >> results.csv
done

echo ",CIS/" >> results.csv
for basis in "3-21G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31+G" "6-31+G(d)" "6-31+G(d,p)" "6-31++G" "6-31++G(d)" "6-31++G(d,p)" "6-311G" "6-311G(d)" "6-311G(d,p)" "6-311G(3d2f,3p2d)" "6-311+G" "6-311+G(d)" "6-311+G(d,p)" "6-311+G(3d2f,3p2d)" "6-311++G" "6-311++G(d)" "6-311++G(d,p)" "6-311++G(3d2f,3p2d)" "cc-pVDZ" "cc-pVTZ" "cc-pVQZ" "cc-pV5Z" "cc-pV6Z" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ" "aug-cc-pV5Z" "aug-cc-pV6Z"; do
  echo -n $basis | sed -e 's/,/_/g' >> results.csv
  echo -n "," >> results.csv
  grep -oP "(?<=Total Energy, E\(CIS/TDA\) = )\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+)" CIS/${basis}.out >> results.csv
done

echo "end"
