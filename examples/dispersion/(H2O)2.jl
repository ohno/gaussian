# using Pkg
# Pkg.add("Markdown")

# packages
using Markdown
using Printf
include("../GaussDrive.jl")
cd(dirname(@__FILE__))

# configuration
basis = "aug-cc-pVDZ"

for method in ["HF" "CCSD" "B3LYP" "CAM-B3LYP" "B3LYP"]

    # file name
    name = "./(H2O)2/$(method)"

    # generating input file
    GaussDrive.write("$name.gjf", 
    """# $(method)/$(basis) Units=AU opt freq
    
    (H2O)2

    0  1
    O  0.0  0.0  0.0
    O  0.0  0.0  4.0
    H  0.0  0.0  2.0
    H  1.7  0.0 -1.7
    H  0.0  1.7  5.7
    H  0.0 -1.7  5.7


    """)
    
    # run
    GaussDrive.run("$name.gjf")
    
end

for method in ["B3LYP"]

    # file name
    name = "./(H2O)2/$(method)-D3"

    # generating input file
    GaussDrive.write("$name.gjf", 
    """# $(method)/$(basis) Units=AU opt EmpiricalDispersion=GD3BJ
    
    (H2O)2

    0  1
    O  0.0  0.0  0.0
    O  0.0  0.0  3.0
    H  0.0  0.0  1.5
    H  1.5  0.0 -1.5
    H  0.0  1.5  4.5
    H  0.0 -1.5  4.5


    """)
    
    # run
    GaussDrive.run("$name.gjf")
    
end

# make table
GaussDrive.table("./(H2O)2/", sort=false) |> Markdown.parse |> display
