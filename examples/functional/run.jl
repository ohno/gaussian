# using Pkg
# Pkg.add("Markdown")

# packages
using Markdown
using Printf
include("../GaussDrive.jl")
cd(dirname(@__FILE__))

# H2

str = raw"""
| H₂, $$R=1.4~a_0$$ | B3LYP | CAM-B3LYP | B3PW91 | MPW1PW91 | HSEH1PBE | WB97XD | APFD |
| :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
"""

for basis in ["STO-3G" "3-21G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31G(3df,3pd)" "6-311G(3df,3pd)"]

    global str *= "| $(basis) |"

    for method in ["B3LYP" "CAM-B3LYP" "B3PW91" "MPW1PW91" "HSEH1PBE" "WB97XD" "APFD"]
        
        # file name
        name = "./H2/$(method)/$(basis)_R=1.4"

        # input
        GaussDrive.write("$(name).gjf", 
            """# $(method)/$(basis) Units=AU

            H2

            0 1
            H  0.0  0.0  0.0
            H  0.0  0.0  1.4


            """
        )
        
        # run
        GaussDrive.run("$(name).gjf")

        # energy
        energy = GaussDrive.energy("$(name).out")
        
        global str *= " $(energy) |"

    end
    
    global str *= "\n"

end

str *= "| best | -1.174475714 | -1.174475714 | -1.174475714 | -1.174475714 | -1.174475714 | -1.174475714 | -1.174475714 |"
    
Markdown.parse(str) |> display

# N2

str = raw"""
| N₂, $$R=1.4~a_0$$ | B3LYP | CAM-B3LYP | B3PW91 | MPW1PW91 | HSEH1PBE | WB97XD | APFD |
| :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
"""

for basis in ["STO-3G" "3-21G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31G(3df,3pd)" "6-311G(3df,3pd)"]

    global str *= "| $(basis) |"

    for method in ["B3LYP" "CAM-B3LYP" "B3PW91" "MPW1PW91" "HSEH1PBE" "WB97XD" "APFD"]
        
        # file name
        name = "./N2/$(method)/$(basis)_R=2.068"

        # input
        GaussDrive.write("$(name).gjf", 
            """# $(method)/$(basis) Units=AU

            N2

            0 1
            N  0.0  0.0  0.0
            N  0.0  0.0  2.068


            """
        )
        
        # run
        GaussDrive.run("$(name).gjf")

        # energy
        energy = GaussDrive.energy("$(name).out")
        
        global str *= " $(energy) |"

    end
    
    global str *= "\n"

end

str *= "| best | -109.5427 | -109.5427 | -109.5427 | -109.5427 | -109.5427 | -109.5427 | -109.5427 |"
    
Markdown.parse(str) |> display
