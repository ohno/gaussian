# using Pkg
# Pkg.add("Markdown")

# packages
using Markdown
using Printf
include("../GaussDrive.jl")
cd(dirname(@__FILE__))

# H

str = """
|  | HF | CID | CISD |
| :-: | :-: | :-: | :-: |
"""

for basis in ["STO-3G" "3-21G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31G(3df,3pd)" "6-311G(3df,3pd)" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ" "aug-cc-pV5Z" "aug-cc-pV6Z"]

    global str *= "| $(basis) |"

    for method in ["HF" "CID" "CISD"]
        
        # file name
        name = "./H/$(method)/$(basis)"

        # input
        GaussDrive.write("$(name).gjf", 
            """# $(method)/$(basis) Units=AU

            H

            0  2
            H  0.0  0.0  0.0


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

str *= "| exact | -0.500000000000 |  |  |"

Markdown.parse(str) |> display

# H2+

str = """
|  | HF | CID | CISD |
| :-: | :-: | :-: | :-: |
"""

for basis in ["STO-3G" "3-21G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31G(3df,3pd)" "6-311G(3df,3pd)" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ" "aug-cc-pV5Z" "aug-cc-pV6Z"]

    global str *= "| $(basis) |"

    for method in ["HF" "CID" "CISD"]
        
        # file name
        name = "./H2+/$(method)/$(basis)_R=2.0"

        # input
        GaussDrive.write("$(name).gjf", 
            """# $(method)/$(basis) Units=AU

            H2+

            1  2
            H  0.0  0.0  0.0
            H  0.0  0.0  2.0


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

str *= "| exact | -0.602634619 |  |  |"
# Scott, T. C., Aubert-Frécon, M., & Grotendorst, J. (2006). Chemical physics, 324(2-3), 323-338. https://doi.org/10.1016/j.chemphys.2005.10.031

Markdown.parse(str) |> display

# H2

str = """
|  | HF | CID | CISD |
| :-: | :-: | :-: | :-: |
"""

for basis in ["STO-3G" "3-21G" "4-31G" "6-31G" "6-31G(d)" "6-31G+(d)" "6-31G(d,p)" "6-31G+(d,p)" "6-31G(3df,3pd)" "6-311G(d,p)" "6-311G+(d,p)" "6-311G++(d,p)" "6-311G(3df,3pd)" "6-311G+(3df,3pd)" "6-311G++(3df,3pd)" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ" "aug-cc-pV5Z" "aug-cc-pV6Z"]

    global str *= "| $(basis) |"

    for method in ["HF" "CID" "CISD"]
        
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

str *= "| HF limit | -1.133629573 | best | -1.174475714 |"
# limit: Sundholm, D. (1988). Chemical physics letters, 149(3), 251-256. https://doi.org/10.1016/0009-2614(88)85022-X
# best: Kurokawa, Y., Nakashima, H., & Nakatsuji, H. (2005). Physical Review A, 72(6), 062502. https://doi.org/10.1103/PhysRevA.72.062502
    
Markdown.parse(str) |> display

# N2

str = """
|  | HF | CID | CISD |
| :-: | :-: | :-: | :-: |
"""

for basis in ["STO-3G" "3-21G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31G(3df,3pd)" "6-311G(3df,3pd)" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ"] #"aug-cc-pV5Z" "aug-cc-pV6Z"]

    global str *= "| $(basis) |"

    for method in ["HF" "CID" "CISD"]
        
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
        println(energy)
        
        global str *= " $(energy) |"

    end
    
    global str *= "\n"

end

str *= "| HF limit | −108.993825700 | best | -109.542700 |"
# limit: 小林正人(2019), Hartree-Fock(-Roothaan)法のエッセンス, フロンティア, http://hdl.handle.net/2115/74383
# best: L. Bytautas and K. Ruedenberg, J. Chem. Phys., 122, 154110 (2005) https://doi.org/10.1063/1.1869493

    
Markdown.parse(str) |> display