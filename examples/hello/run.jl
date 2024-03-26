# Table 3.2

# using Pkg
# Pkg.add("Markdown")

# packages
using Markdown
using Printf
include("../GaussDrive.jl")
cd(dirname(@__FILE__))

# configuration
method = "HF"
basis = "STO-3G"

for R in [1.32, 1.34, 1.36, 1.38, 1.40]

    # file name
    s = @sprintf("%.2f", R)
    name = "./R=$s"

    # generating input file
    GaussDrive.write("$name.gjf", 
    """# $(method)/$(basis) units=au

    H2

    0  1
    H  0.0  0.0  0.0
    H  0.0  0.0  $(s)


    """)

    # run
    GaussDrive.run("$name.gjf")
    
end
    
# make table
GaussDrive.table("./") |> Markdown.parse |> display
