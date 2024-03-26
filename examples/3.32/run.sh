#!/bin/bash
# Author     | Shuhei Ohno
# Licence    | CC-BY-4.0
# Repository | https://github.com/ohno/gaussian
# Comments   | run on WSL(Ubuntu)

# input
for basis in "STO-3G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-311++G(d,p)" "6-311++G(3df,2pd)"; do
for method in "HF" "B3LYP" "G3"; do

  if [ ${method} = "G3" ]; then
    level="G3"
  else
    level="${method}/${basis}"
  fi

  # mkdir
  folder=$(cd $(dirname $0); pwd)
  cd $folder
  mkdir -p $level

# H2
echo "# ${level} opt freq=ReadIsotopes

H2

0  1
H  0.0  0.0  0.0
H  0.0  0.0  1.0

298.15  1.0
1
1

" > "${level}/H2.gjf"

# CO
echo "# ${level} opt freq=ReadIsotopes

CO

0  1
C  0.0  0.0  0.0
O  0.0  0.0  2.0

298.15  1.0
12
16

" > "${level}/CO.gjf"

# N2
echo "# ${level} opt freq=ReadIsotopes

N2

0  1
N  0.0  0.0  0.0
N  0.0  0.0  2.0

298.15  1.0
14
14

" > "${level}/N2.gjf"

# H2O
echo "# ${level} opt freq=ReadIsotopes

H2O

0  1
O
H  1  B1
H  1  B1  2  A1

B1    0.96
A1  109.50

298.15  1.0
16
1
1

" > "${level}/H2O.gjf"

# NH3
echo "# ${level} opt freq=ReadIsotopes

NH3

0  1
N  
H  1  B1
H  1  B1  2  A1
H  1  B1  3  A1  2  D1  0

B1   1.0
A1   109.47120255
D1  -120.0

298.15  1.0
14
1
1
1

" > "${level}/NH3.gjf"

# CH4
echo "# ${level} opt freq=ReadIsotopes

CH4

0  1
C
H  1  B1
H  1  B1  2  A1
H  1  B1  3  A1  2  D1  0
H  1  B1  3  A1  2  D2  0

B1     1.07000000
A1   109.47120255
D1  -120.0
D2   120.0

298.15  1.0
12
1
1
1
1

" > "${level}/CH4.gjf"

  # run
  bash ../g16.sh $level

done
done

# grep

echo "energy"
echo "energy,H2,N2,CO,H2O,NH3,CH4" > results.csv
for basis in "STO-3G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-311++G(d,p)" "6-311++G(3df,2pd)"; do
for method in "HF" "B3LYP" "G3"; do
  if [ ${method} = "G3" ]; then
    level="G3"
    if [ ${basis} = "6-311++G(3df,2pd)" ]; then
      echo -n "${level}" | sed -e 's/,/_/g' >> results.csv
      echo -n "," >> results.csv
      for molecule in "H2" "N2" "CO" "H2O" "NH3" "CH4"; do
        energy=$(grep -oP "(?<=E\(QCISD\(T\)\)=)\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+)\s" "${level}/${molecule}.out")
        echo "${level}/${molecule}.out $energy"
        echo -n "$energy," >> results.csv
      done
      echo "" >> results.csv
    fi
  else
    level="${method}/${basis}"
    echo -n "${level}" | sed -e 's/,/_/g' >> results.csv
    echo -n "," >> results.csv
    for molecule in "H2" "N2" "CO" "H2O" "NH3" "CH4"; do
      energy=$(grep "SCF Done" "${level}/${molecule}.out" | tail -1 | grep -oP "(?<=\=)\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+)\s")
      echo "${level}/${molecule}.out $energy"
      echo -n "$energy," >> results.csv
    done
    echo "" >> results.csv
  fi
done
done

echo "EE+ZPE"
echo "EE+ZPE,H2,N2,CO,H2O,NH3,CH4" >> results.csv
for basis in "STO-3G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-311++G(d,p)" "6-311++G(3df,2pd)"; do
for method in "HF" "B3LYP" "G3"; do
  if [ ${method} = "G3" ]; then
    level="G3"
    if [ ${basis} = "6-311++G(3df,2pd)" ]; then
      echo -n "${level}" | sed -e 's/,/_/g' >> results.csv
      echo -n "," >> results.csv
      for molecule in "H2" "N2" "CO" "H2O" "NH3" "CH4"; do
        energy=$(grep -oP "(?<=G3\(0 K\)=)\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+)\s" "${level}/${molecule}.out")
        echo "${level}/${molecule}.out $energy"
        echo -n "$energy," >> results.csv
      done
      echo "" >> results.csv
    fi
  else
    level="${method}/${basis}"
    echo -n "${level}" | sed -e 's/,/_/g' >> results.csv
    echo -n "," >> results.csv
    for molecule in "H2" "N2" "CO" "H2O" "NH3" "CH4"; do
      energy=$(grep -oP "(?<=Sum of electronic and zero-point Energies=)\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+)" "${level}/${molecule}.out")
      echo "${level}/${molecule}.out $energy"
      echo -n "$energy," >> results.csv
    done
    echo "" >> results.csv
  fi
done
done

echo "enthalpy"
echo "enthalpy,H2,N2,CO,H2O,NH3,CH4" >> results.csv
for basis in "STO-3G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-311++G(d,p)" "6-311++G(3df,2pd)"; do
for method in "HF" "B3LYP" "G3"; do
  if [ ${method} = "G3" ]; then
    level="G3"
    if [ ${basis} = "6-311++G(3df,2pd)" ]; then
      echo -n "${level}" | sed -e 's/,/_/g' >> results.csv
      echo -n "," >> results.csv
      for molecule in "H2" "N2" "CO" "H2O" "NH3" "CH4"; do
        energy=$(grep -oP "(?<=G3 Enthalpy=)\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+)\s" "${level}/${molecule}.out")
        echo "${level}/${molecule}.out $energy"
        echo -n "$energy," >> results.csv
      done
      echo "" >> results.csv
    fi
  else
    level="${method}/${basis}"
    echo -n "${level}" | sed -e 's/,/_/g' >> results.csv
    echo -n "," >> results.csv
    for molecule in "H2" "N2" "CO" "H2O" "NH3" "CH4"; do
      energy=$(grep -oP "(?<=Sum of electronic and thermal Enthalpies=)\s*(?<target>[+-]?\d+(?:\.\d+)?[ED]?[+-]?\d+)" "${level}/${molecule}.out")
      echo "${level}/${molecule}.out $energy"
      echo -n "$energy," >> results.csv
    done
    echo "" >> results.csv
  fi
done
done

echo "end"
