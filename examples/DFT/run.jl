# using Pkg
# Pkg.add("Markdown")

# packages
using Markdown
using Printf
include("../GaussDrive.jl")
cd(dirname(@__FILE__))

# H2

str = "H2-R=1.4a0,LSDA,BLYP,B3LYP,CAM-B3LYP,PBE1PBE,HSEH1PBE,APFD,wB97XD\n"

for basis in ["STO-3G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31++G(d,p)" "6-311++G(d,p)" "6-311++G(3df,2pd)" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ"]

    global str *= replace(basis, ","=>"_")

    for method in ["SVWN" "BLYP" "B3LYP" "CAM-B3LYP" "PBE1PBE" "HSEH1PBE" "APFD" "wB97XD"]
        
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
        
        global str *= ",$(energy)"

    end
    
    global str *= "\n"

end

str *= "best,-1.174475714\n"

# N2

str *= "N2-R=1.4a0,LSDA,BLYP,B3LYP,CAM-B3LYP,PBE1PBE,HSEH1PBE,APFD,wB97XD\n"

for basis in ["STO-3G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31++G(d,p)" "6-311++G(d,p)" "6-311++G(3df,2pd)" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ"]

    global str *= replace(basis, ","=>"_")

    for method in ["SVWN" "BLYP" "B3LYP" "CAM-B3LYP" "PBE1PBE" "HSEH1PBE" "APFD" "wB97XD"]
        
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
        
        global str *= ",$(energy)"

    end
    
    global str *= "\n"

end

str *= "best,-109.5427\n"

GaussDrive.write("./results.csv", str)
