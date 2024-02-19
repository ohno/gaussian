#!/bin/bash
# Author     | Shuhei Ohno
# Licence    | CC-BY-4.0
# Repository | https://github.com/ohno/gaussian
# Comments   | run on WSL(Ubuntu)

# g16.exe & scratch directory
export GAUSS_EXEDIR=~/../../G16W/ # change here!
export GAUSS_SCRDIR=./Scratch/
[ ! -d "$GAUSS_SCRDIR" ]&&mkdir -p "$GAUSS_SCRDIR"

# run
# g16.exe STO-3G.gjf
# g16.exe  4-31G.gjf
# g16.exe  6-31G.gjf
bash ../g16.sh .

# chk to fchk
formchk.exe STO-3G.chk STO-3G.fchk
formchk.exe  4-31G.chk  4-31G.fchk
formchk.exe  6-31G.chk  6-31G.fchk

# clean up
rm -rf $GAUSS_SCRDIR
rm -f Gau-*.inp
rm -f Gau-*.chk
rm -f Gau-*.d2e
rm -f Gau-*.rwf
rm -f Gau-*.int
rm -f Gau-*.skr
rm -f Gau-*.nbo
rm -f fort.*

# grep
grep -n "primitive gaussians" *.out