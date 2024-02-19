#!/bin/bash
# Author     | Shuhei Ohno
# Licence    | CC-BY-4.0
# Repository | https://github.com/ohno/gaussian
# Comments   | run on WSL(Ubuntu), https://gaussian.com/formchk/

# argument check
if [ $# -lt 1 ]; then
  echo "Wrong usage!!"
  echo "Run \`bash formchk.sh <path>\`"
  exit
fi

# running g16.exe $1
function run() {
  echo "formchk.exe $1 ${1//.chk/.fchk}"
  if [[ -e ${1//.chk/.fchk} ]]; then
    echo "> already done"
  else
    echo  "wait..." > ${1//.chk/.fchk}
    formchk.exe $1 ${1//.chk/.fchk}
    echo "> done"
  fi

  echo ${file}
  echo ${file//.gjf/.out}
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
  for file in *.chk; do
    run $file
  done
fi
