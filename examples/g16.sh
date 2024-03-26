#!/bin/bash
# Author     | Shuhei Ohno
# Licence    | CC-BY-4.0
# Repository | https://github.com/ohno/gaussian
# Comments   | run on WSL(Ubuntu)

# argument check
if [ $# -lt 1 ]; then
  echo "Wrong usage!!"
  echo "Run \`bash g16.sh <path>\`"
  exit
fi

# g16.exe & scratch directory
export GAUSS_EXEDIR=~/../../G16W/
export GAUSS_SCRDIR=./Scratch/
[ ! -d "$GAUSS_SCRDIR" ]&&mkdir -p "$GAUSS_SCRDIR"

# running g16.exe $1
function run() {
  echo -n "g16.exe $1 "
  if [[ -e ${1//.gjf/.out} ]]; then
    echo "> already done"
  else
    echo  "wait..." > ${1//.gjf/.out}
    g16.exe $1 #>& ${1//.gjf/.out}
    echo "> ${1//.gjf/.out}"
  fi
}

# for a file
if [ -f $1 ]; then
  # echo $1 " is a file."
  run $1
fi

# for a directory
if [ -d $1 ]; then
  # echo "$1 is a directory."
  echo "cd $1"
  cd $1
  for file in *.gjf; do
    run $file
  done
fi

# clean up
# rm -rf $GAUSS_SCRDIR/*
rm -f Gau-*.inp
rm -f Gau-*.chk
rm -f Gau-*.d2e
rm -f Gau-*.rwf
rm -f Gau-*.int
rm -f Gau-*.skr
rm -f Gau-*.nbo
rm -f fort.*