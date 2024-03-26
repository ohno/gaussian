#!/bin/bash
# Author     | Shuhei Ohno
# Licence    | CC-BY-4.0
# Repository | https://github.com/ohno/gaussian
# Comments   | run on WSL(Ubuntu)

# input
for method in "HF" "MP2" "B3LYP"; do

mkdir -p H2O/$method

for basis in "STO-3G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31++G(d,p)" "6-311++G(d,p)" "6-311++G(3df,2pd)" "6-311++G(3df,3pd)" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ"; do

# H2O
echo "# ${method}/${basis} Opt Freq=Anharmonic

H2O

0 1
O
H  1  B1
H  1  B1  2  A1

B1    0.96
A1  109.50


" > "H2O/${method}/${basis}.gjf"

bash ../g16.sh "H2O/${method}/${basis}.gjf"
# grep "Frequencies --" "H2O/${method}/*.out"
grep -A 3 "Mode(n)      Status" "H2O/${method}/${basis}.out"

done
done
