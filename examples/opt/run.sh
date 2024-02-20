#!/bin/bash

# mkdir
for method in "HF" "B3LYP" "CCSD"; do
for system in "H2+" "H2" "N2" "CO" "CH4" "NH3" "H2O" "FH"; do
  folder=$(cd $(dirname $0); pwd)
  cd $folder
  mkdir -p $system/$method
done
done

# input
for method in "HF" "B3LYP" "CCSD"; do
for basis in "STO-3G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)"; do

echo "# ${method}/${basis} Units=AU opt

H2+

1 2
H  0.0  0.0  0.0
H  0.0  0.0  2.0

" > "H2+/${method}/${basis}.gjf"

echo "# ${method}/${basis} Units=AU opt

H2

0 1
H 0.0 0.0 0.0
H 0.0 0.0 1.4

" > "H2/${method}/${basis}.gjf"

echo "# ${method}/${basis} Units=AU opt

N2

0 1
N  0.0  0.0  0.0
N  0.0  0.0  2.068

" > "N2/${method}/${basis}.gjf"

echo "# ${method}/${basis} Units=AU opt

CO

0 1
C  0.0  0.0  0.0
O  0.0  0.0  2.068

" > "CO/${method}/${basis}.gjf"

echo "# ${method}/${basis} opt

CH4

0 1
C
H  1  B1
H  1  B1  2  A1
H  1  B1  3  A1  2  D1  0
H  1  B1  3  A1  2  D2  0

B1     1.07000000
A1   109.47120255
D1  -120.0
D2   120.0

" > "CH4/${method}/${basis}.gjf"

echo "# ${method}/${basis} opt

NH3

0 1
N  
H  1  B1
H  1  B1  2  A1
H  1  B1  3  A1  2  D1  0

B1   1.0
A1   109.47120255
D1  -120.0

" > "NH3/${method}/${basis}.gjf"

echo "# ${method}/${basis} opt

H2O

0 1
O
H  1  B1
H  1  B1  2  A1

B1    0.96000000
A1  109.50000006

" > "H2O/${method}/${basis}.gjf"

echo "# ${method}/${basis} opt

FH

0 1
F  0.0  0.0  0.0
H  0.0  0.0  2.0

" > "FH/${method}/${basis}.gjf"

done
done

# run
for method in "HF" "B3LYP" "CCSD"; do
for basis in "STO-3G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)"; do
for system in "H2+" "H2" "N2" "CO" "CH4" "NH3" "H2O" "FH"; do
  bash ../g16.sh "${system}/${method}/${basis}.gjf"
done
done
done

# grep
result="results.csv"
echo "" > $result

for system in "H2+" "H2" "N2" "CO" "CH4" "NH3" "H2O" "FH"; do
  # energy
  echo "" >> $result
  echo $system >> $result
  echo "energy[Hartree]" >> $result
  echo "basis,HF,B3LYP,CCSD" >> $result
  for basis in "STO-3G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d\,p)"; do
    echo -n ${basis//,/} >> $result
    for method in "HF" "B3LYP" "CCSD"; do
      file="${system}/${method}/${basis}.out"
      if [ $method = "HF" ] || [ $method = "B3LYP" ]; then
        raw=`grep "SCF Done" $file | tail -n 1`
        left=${raw%% A.U.*}
        right=${left##*= }
      else
        raw=`grep "Wavefunction amplitudes converged. " $file | tail -n 1`
        right=${raw##*= }
      fi
      energy=${right// /}
      echo -n ",$energy" >> $result
    done
    echo "" >> $result
  done
  # distance
  echo "" >> $result
  echo $system >> $result
  echo "distance[ang]" >> $result
  echo "basis,HF,B3LYP,CCSD" >> $result
  for basis in "STO-3G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)"; do
    echo -n ${basis//,/} >> $result
    for method in "HF" "B3LYP" "CCSD"; do
      file="${system}/${method}/${basis}.out"
      raw=`grep "! R1" $file | tail -n 1`
      left=${raw%%-DE/DX*}
      right=${left##*R(1,2)}
      distance=${right// /}
      echo -n ",$distance" >> $result
    done
    echo "" >> $result
  done
done

echo "end"