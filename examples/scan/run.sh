#!/bin/bash
# Author     | Shuhei Ohno
# Licence    | CC-BY-4.0
# Repository | https://github.com/ohno/gaussian
# Comments   | run on WSL(Ubuntu)

#!/bin/bash

# input
for method in "MP4"; do #"HF" "CID" "CISD" "CCD" "CCSD" "MP2" "MP3" "MP4" "B3LYP"; do
for basis in "6-31G(d,p)"; do # "STO-3G" "6-31G(d,p)"; do
echo "# ${method}/$basis SCAN Guess=(mix,always,nosym)

H2

0 1
H
H 1 R1
Variables:
R1 0.5 13 0.5



" > "${method}_${basis}.gjf"
done
done

# run
folder=$(cd $(dirname $0); pwd)
bash ../g16.sh $folder

# # grep
# result="auto.csv"
# echo $folder > $result
# grep "SCF Done" *.out >> $result
# grep "Job cpu time" *.out >> $result

echo "end"