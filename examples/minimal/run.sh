#!/bin/bash
# Author     | Shuhei Ohno
# Licence    | CC-BY-4.0
# Repository | https://github.com/ohno/gaussian
# Comments   | run on WSL(Ubuntu)

for R in "1.30" "1.32" "1.34" "1.36" "1.38" "1.40"; do
echo "# HF/STO-3G Units=AU

H2

0  1
H  0.0  0.0  0.0
H  0.0  0.0  $R

" > "R=${R}.gjf"
done

bash ../g16.sh ./
grep -n " SCF Done:" *.out
echo "end"