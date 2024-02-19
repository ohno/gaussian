#!/bin/bash
# Author     | Shuhei Ohno
# Licence    | CC-BY-4.0
# Repository | https://github.com/ohno/gaussian
# Comments   | run on WSL(Ubuntu)

# setup
ulimit -s unlimited
source /opt/intel/oneapi/setvars.sh
export OMP_STACKSIZE=8M
export OMP_NUM_THREADS=2

# run
~/smash/smash/bin/smash < smash.inp > smash.out

# clean up
# rm input.dat*