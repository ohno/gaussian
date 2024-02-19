# using Pkg
# Pkg.add("Markdown")

# packages
using Markdown
using Printf
include("../GaussDrive.jl")
cd(dirname(@__FILE__))

# configuration
basis = "aug-cc-pVTZ"

for method in ["HF" "B3LYP" "CCSD"]

    # file name
    name = "./He2/$(method)"

    # generating input file
    GaussDrive.write("$name.gjf", 
    """# $(method)/$(basis) Units=AU opt
    
    He2

    0 1
    He  0.0  0.0  0.0
    He  0.0  0.0  2.0


    """)
    
    # run
    GaussDrive.run("$name.gjf")
    
end

for method in ["B3LYP"]

    # file name
    name = "./He2/$(method)-3D"

    # generating input file
    GaussDrive.write("$name.gjf", 
    """# $(method)/$(basis) Units=AU opt EmpiricalDispersion=GD3BJ
    
    He2

    0 1
    He  0.0  0.0  0.0
    He  0.0  0.0  2.0


    """)
    
    # run
    GaussDrive.run("$name.gjf")
    
end

# make table
GaussDrive.table("./He2/", sort=false) |> Markdown.parse |> display
