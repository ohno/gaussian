# using Pkg
# Pkg.add("Markdown")

# packages
using Markdown
using Printf
include("../GaussDrive.jl")
cd(dirname(@__FILE__))

# atom

for atom in ["H" "He" "Li" "Be" "B" "C" "N" "O" "F" "Ne" "Ar" "Kr"]
    for method in ["HF"]
        for basis in ["STO-3G" "3-21G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31G(3df,3pd)" "6-31+G" "6-31+G(d)" "6-31+G(d,p)" "6-31+G(3df,3pd)" "6-31++G" "6-31++G(d)" "6-31++G(d,p)" "6-31++G(3df,3pd)" "6-311G" "6-311G(d)" "6-311G(d,p)" "6-311G(3df,3pd)" "6-311+G" "6-311+G(d)" "6-311+G(d,p)" "6-311+G(3df,3pd)" "6-311++G" "6-311++G(d)" "6-311++G(d,p)" "6-311++G(3df,3pd)" "cc-pVDZ" "cc-pVTZ" "cc-pVQZ" "cc-pV5Z" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ" "aug-cc-pV5Z" "EPR-II" "EPR-III"]
            # file name
            name = "./$(atom)/$(method)/$(basis)"
            # generating input file
            GaussDrive.write("$(name).gjf", 
                """# $(method)/$(basis) GFPrint

                $atom

                0  $(atom∈["H" "Li" "B" "N" "F"] ? 2 : 1)
                $atom  0.0  0.0  0.0


                """
            )
            # run
            GaussDrive.run("$(name).gjf")
        end
    # make table
    GaussDrive.table("./$(atom)/$(method)/") |> Markdown.parse |> display
    end
end

text = ""
for atom in ["H" "He" "Li" "Be" "B" "C" "N" "O" "F" "Ne" "Ar" "Kr"]
    global text *= ",$atom"
end
global text *= "\n"

for basis in ["STO-3G" "3-21G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31G(3df,3pd)" "6-31+G" "6-31+G(d)" "6-31+G(d,p)" "6-31+G(3df,3pd)" "6-31++G" "6-31++G(d)" "6-31++G(d,p)" "6-31++G(3df,3pd)" "6-311G" "6-311G(d)" "6-311G(d,p)" "6-311G(3df,3pd)" "6-311+G" "6-311+G(d)" "6-311+G(d,p)" "6-311+G(3df,3pd)" "6-311++G" "6-311++G(d)" "6-311++G(d,p)" "6-311++G(3df,3pd)" "cc-pVDZ" "cc-pVTZ" "cc-pVQZ" "cc-pV5Z" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ" "aug-cc-pV5Z" "EPR-II" "EPR-III"]
    global text *= replace(basis, ","=>"_")
    for atom in ["H" "He" "Li" "Be" "B" "C" "N" "O" "F" "Ne" "Ar" "Kr"]
        name = "./$(atom)/HF/$(basis)"
        n = GaussDrive.get("$(name).out", r"NBasis=\s*(?<target>\d+?)\s", type=Int)
        global text *= ",$n"
    end
    global text *= "\n"
end

text *= "\n"
for atom in ["H" "He" "Li" "Be" "B" "C" "N" "O" "F" "Ne" "Ar" "Kr"]
    global text *= ",$atom"
end
global text *= "\n"

for basis in ["STO-3G" "3-21G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31G(3df,3pd)" "6-31+G" "6-31+G(d)" "6-31+G(d,p)" "6-31+G(3df,3pd)" "6-31++G" "6-31++G(d)" "6-31++G(d,p)" "6-31++G(3df,3pd)" "6-311G" "6-311G(d)" "6-311G(d,p)" "6-311G(3df,3pd)" "6-311+G" "6-311+G(d)" "6-311+G(d,p)" "6-311+G(3df,3pd)" "6-311++G" "6-311++G(d)" "6-311++G(d,p)" "6-311++G(3df,3pd)" "cc-pVDZ" "cc-pVTZ" "cc-pVQZ" "cc-pV5Z" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ" "aug-cc-pV5Z" "EPR-II" "EPR-III"]
    global text *= replace(basis, ","=>"_")
    for atom in ["H" "He" "Li" "Be" "B" "C" "N" "O" "F" "Ne" "Ar" "Kr"]
        name = "./$(atom)/HF/$(basis)"
        ns  = GaussDrive.count("$(name).out", r"\sAtom.*Shell.*S\s")
        nsp = GaussDrive.count("$(name).out", r"\sAtom.*Shell.*SP\s")
        np  = GaussDrive.count("$(name).out", r"\sAtom.*Shell.*P\s")
        nd  = GaussDrive.count("$(name).out", r"\sAtom.*Shell.*D\s")
        nf  = GaussDrive.count("$(name).out", r"\sAtom.*Shell.*F\s")
        ng  = GaussDrive.count("$(name).out", r"\sAtom.*Shell.*G\s")
        nh  = GaussDrive.count("$(name).out", r"\sAtom.*Shell.*H\s")
        ni  = GaussDrive.count("$(name).out", r"\sAtom.*Shell.*I\s")
        if ns > 0;  global text *= ",$(ns)s" ; end
        if nsp > 0; global text *= "$(nsp)sp"; end
        if np > 0;  global text *= "$(np)p"  ; end
        if nd > 0;  global text *= "$(nd)d"  ; end
        if nf > 0;  global text *= "$(nf)f"  ; end
        if ng > 0;  global text *= "$(ng)g"  ; end
        if nh > 0;  global text *= "$(nh)h"  ; end
        if ni > 0;  global text *= "$(ni)i"  ; end
    end
    global text *= "\n"
end

GaussDrive.write("./results.csv", text)

# H2

for method in ["HF"]
    for basis in ["STO-3G" "3-21G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31G(3df,3pd)" "6-31+G" "6-31+G(d)" "6-31+G(d,p)" "6-31+G(3df,3pd)" "6-31++G" "6-31++G(d)" "6-31++G(d,p)" "6-31++G(3df,3pd)" "6-311G" "6-311G(d)" "6-311G(d,p)" "6-311G(3df,3pd)" "6-311+G" "6-311+G(d)" "6-311+G(d,p)" "6-311+G(3df,3pd)" "6-311++G" "6-311++G(d)" "6-311++G(d,p)" "6-311++G(3df,3pd)" "cc-pVDZ" "cc-pVTZ" "cc-pVQZ" "cc-pV5Z" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ" "aug-cc-pV5Z" "EPR-II" "EPR-III"]
        # file name
        name = "./H2/$(method)/$(basis)"  
        # generating input file
        GaussDrive.write("$(name).gjf", 
            """# $(method)/$(basis) Units=AU GFPrint

            H2

            0  1
            H  0.0  0.0  0.0
            H  0.0  0.0  1.4


            """
        )
        # run
        GaussDrive.run("$(name).gjf")        
    end
    # make table
    GaussDrive.table("./H2/$(method)/") |> Markdown.parse |> display

end
