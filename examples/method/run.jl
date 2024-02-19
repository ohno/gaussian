# using Pkg
# Pkg.add("Markdown")

# packages
using Markdown
using Printf
include("../GaussDrive.jl")
cd(dirname(@__FILE__))

# H

str = """
|  | /STO-3G | /6-31G(d,p) |
| :-: | :-: | :-: |
"""

for method in ["HF" "CID" "CISD" "CCS" "CCD" "CCSD" "MP2" "MP3" "MP4" "B3LYP" "BLYP" "CAM-B3LYP" "B3PW91" "MPW1PW91" "HSEH1PBE" "WB97XD" "APFD"]
        
    global str *= "| $(method) |"

        for basis in ["STO-3G" "6-31G(d,p)"]
        
        # file name
        name = "./H/$(method)/$(basis)_R=1.4"

        # input
        GaussDrive.write("$(name).gjf", 
            """# $(method)/$(basis) Units=AU

            H

            0 2
            H 0.0 0.0 0.0


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
    
Markdown.parse(str) |> display

# H2

str = """
|  | /STO-3G | /6-31G(d,p) |
| :-: | :-: | :-: |
"""

for method in ["HF" "CID" "CISD" "CCS" "CCD" "CCSD" "MP2" "MP3" "MP4" "B3LYP" "BLYP" "CAM-B3LYP" "B3PW91" "MPW1PW91" "HSEH1PBE" "WB97XD" "APFD"]
        
    global str *= "| $(method) |"

        for basis in ["STO-3G" "6-31G(d,p)"]
        
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
    
Markdown.parse(str) |> display