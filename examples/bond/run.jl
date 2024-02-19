# using Pkg
# Pkg.add("Markdown")

# packages
using Markdown
using Printf
include("../GaussDrive.jl")
cd(dirname(@__FILE__))

# configuration
method = "HF"
basis = "6-31G(d,p)"

# C2H2
GaussDrive.write("./C2H2.gjf", 
"""%chk=C2H2
# $(method)/$(basis) opt freq

C2H2

0  1
C  0.0  0.0  1.0
C  0.0  0.0  2.0
H  0.0  0.0 -1.0
H  0.0  0.0  3.0


""")

# C2H4
GaussDrive.write("./C2H4.gjf", 
"""%=C2H4
# $(method)/$(basis) opt freq

C2H4

0  1
C  0.0  0.0  1.0
C  0.0  0.0  2.0
H  0.0  1.0  0.0
H  0.0 -1.0  0.0
H  0.0  1.0  3.0
H  0.0 -1.0  3.0


""")

# C2H6
GaussDrive.write("./C2H6.gjf", 
"""%chk=C2H6
# $(method)/$(basis) opt freq

C2H6

0  1
C  0.0  0.0  1.0
C  0.0  0.0  2.0
H  0.0  1.0  0.0
H  0.0 -1.0  0.0
H  1.0  0.0  0.0
H  0.0  1.0  3.0
H  0.0 -1.0  3.0
H  1.0  0.0  3.0


""")

# run
GaussDrive.run("./C2H2.gjf")
GaussDrive.run("./C2H4.gjf")
GaussDrive.run("./C2H6.gjf")

# make table
GaussDrive.table("./", sort=false) |> Markdown.parse |> display
