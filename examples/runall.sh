#!/bin/bash
# Author     | Shuhei Ohno
# Licence    | CC-BY-4.0
# Repository | https://github.com/ohno/gaussian
# Comments   | run on WSL(Ubuntu)


# bash g16.sh hello.gjf

# cd software
#   cmd.exe /c gamess.bat
#   bash smash.sh
#   bash gaussian.sh
# cd ..

# cd minimal
#   bash run.sh
# cd ..

# cd bond
#   bash run.sh
# cd ..

# bash g16.sh modeling

# bash g16.sh frontier

# cd fchk
#   bash run.sh
# cd ..

# cd correlation
#   bash run.sh
# cd ..

# bash g16.sh PBC/graphene.gjf

# bash g16.sh solvent
# bash g16.sh anharmonic
# grep "Frequencies --" ./anharmonic/*.out

bash g16.sh isotope
# grep "Frequencies --" ./anharmonic/*.out

