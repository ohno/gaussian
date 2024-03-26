#!/bin/bash
# Author     | Shuhei Ohno
# Licence    | CC-BY-4.0
# Repository | https://github.com/ohno/gaussian
# Comments   | run on WSL(Ubuntu)

# input
for method in "HF"; do

mkdir -p H2+/$method
mkdir -p H2O/$method

for basis in "STO-3G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31++G(d,p)" "6-311++G(d,p)" "6-311++G(3df,2pd)" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ"; do

# H2+
echo "# ${method}/${basis} Opt Freq

H2

1  2
H  0.0  0.0  0.0
H  0.0  0.0  1.0


" > "H2+/${method}/${basis}.gjf"

bash ../g16.sh "H2+/${method}/${basis}.gjf"

# H2O
echo "# ${method}/${basis} Opt Freq

H2O

0  1
O  0.0  0.0  0.0
H  0.0  1.4  1.4
H  0.0  1.4  -1.4


" > "H2O/${method}/${basis}.gjf"

bash ../g16.sh "H2O/${method}/${basis}.gjf"

done
done

echo -n "" > results.csv

for method in "HF"; do
for basis in "STO-3G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31++G(d,p)" "6-311++G(d,p)" "6-311++G(3df,2pd)" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ"; do
  e1=$(grep "SCF Done:" "H2+/${method}/${basis}.out" | tail -n 1)
  e1=$(echo $e1 | grep -oP "(?<=E\(UHF\) = )\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+)\s*")
  e2=$(grep -oP "(?<=Sum of electronic and zero-point Energies= )\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+)" "H2+/${method}/${basis}.out")
  echo -n "$method," >> results.csv
  echo -n "${basis/,/_}," >> results.csv
  echo -n "$e1," >> results.csv
  echo "$e2" >> results.csv
done
done

for method in "HF"; do
for basis in "STO-3G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31++G(d,p)" "6-311++G(d,p)" "6-311++G(3df,2pd)" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ"; do
  frequencies=$(grep -oP "(?<=Frequencies --).*" "H2O/${method}/${basis}.out")
  list=(${frequencies/\s// })
  v1=${list[0]}
  v2=${list[1]}
  v3=${list[2]}
  echo -n "$method," >> results.csv
  echo -n "${basis/,/_}," >> results.csv
  echo -n "$v1", >> results.csv
  echo -n "$v2", >> results.csv
  echo "$v3" >> results.csv
done
done

