#!/bin/bash
# Author     | Shuhei Ohno
# Licence    | CC-BY-4.0
# Repository | https://github.com/ohno/gaussian
# Comments   | run on WSL(Ubuntu)

# reset
echo ",H2,O2,H2O" > results.csv

# input
for basis in "cc-pVTZ" "aug-cc-pVTZ" "6-311++G(d,p)" "6-311++G(3df,2pd)"; do
for method in "HF" "B3LYP" "CCSD" "G3"; do

  if [ ${method} = "G3" ]; then
    level="G3"
  else
    level="${method}/${basis}"
  fi

  # mkdir
  folder=$(cd $(dirname $0); pwd)
  cd $folder
  for molecule in "H2" "O2" "H2O"; do
    file=${molecule}/${level}.gjf
    mkdir -p "$(dirname "$file")" && touch "$file"
  done

# H2
echo "# ${level} opt freq=ReadIsotopes

H2

0  1
H  0.0  0.0  0.0
H  0.0  0.0  1.0

298.15  1.0
1
1

" > "H2/${level}.gjf"

# O2
echo "# ${level} opt freq=ReadIsotopes

O2 (triplet)

0  3
O  0.0  0.0  0.0
O  0.0  0.0  2.2

298.15  1.0
16
16

" > "O2/${level}.gjf"

# H2O
echo "# ${level} opt freq=ReadIsotopes

H2O

0 1
O
H  1  B1
H  1  B1  2  A1

B1    0.96
A1  109.50

298.15  1.0
16
1
1

" > "H2O/${level}.gjf"

  # run
  bash ../g16.sh H2
  bash ../g16.sh H2/${method}
  bash ../g16.sh O2
  bash ../g16.sh O2/${method}
  bash ../g16.sh H2O
  bash ../g16.sh H2O/${method}

  # grep
  echo -n "${level}" | sed -e 's/,/_/g' >> results.csv
  echo -n "," >> results.csv

  for molecule in "H2" "O2" "H2O"; do
    if [ ${method} = "G3" ]; then
      energy=$(grep -oP "(?<=G3 Enthalpy=)\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+)\s" "${molecule}/${level}.out")
    else
      energy=$(grep -oP "(?<=Sum of electronic and thermal Enthalpies=)\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+)" "${molecule}/${level}.out")
    fi
    echo "${molecule}/${level}.out $energy"
    echo -n "$energy," >> results.csv
  done
  echo "" >> results.csv

done
done

echo "end"
