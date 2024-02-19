@REM Author     | Shuhei Ohno
@REM Licence    | CC0 1.0 Universal
@REM Repository | https://github.com/ohno/gaussian
@REM Comments   | run on Windows

@REM get-version-names
cd C:\Users\Public\gamess-64
rungms %~dp0\gamess.inp 2021.R2.P2.intel.msucc 1 %~dp0\gamess.log

@REM pause