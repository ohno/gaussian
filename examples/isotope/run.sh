#!/bin/bash
# Author     | Shuhei Ohno
# Licence    | CC-BY-4.0
# Repository | https://github.com/ohno/gaussian
# Comments   | run on WSL(Ubuntu)

bash ../g16.sh ./
grep -A 3 "Mode(n)      Status" *.out
