#!/bin/bash
# Author     | Shuhei Ohno
# Licence    | CC-BY-4.0
# Repository | https://github.com/ohno/gaussian
# Comments   | run on WSL(Ubuntu)

bash ../g16.sh ./
grep -n "SCF Done:" *.out
grep -n "R1    R(1,2).*-DE/DX" *.out
 
echo "end"