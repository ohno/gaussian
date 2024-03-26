# using Pkg
# Pkg.add("Markdown")

# packages
using Markdown
using Printf
include("../GaussDrive.jl")
cd(dirname(@__FILE__))

# configuration

results = Dict()
text = ""
methods = ["CIS" "TD B3LYP" "TD HSEH1PBE" "TD APFD" "TD CAM-B3LYP" "TD wB97XD"]
atoms = ["Li" "Na" "K" "Rb" "Cu" "B" "P" "Ca" "Sr"]

for basis in ["6-31G(d,p)" "6-311G(d,p)" "6-311G(3df,2pd)" "Lanl2DZ" "SDD"]

  for method in methods
    for atom in atoms
        
      # file name
      name = replace("./$(method)/$(basis)/$(atom)", " " => "")

      # file name
      GaussDrive.write("$(name).gjf", 
          """# $(method)/$(basis) guess=mix

          $(atom)

          0 $(atom in ["Ca" "Sr"] ? 1 : 2)
          $(atom)  0.0  0.0  0.0


          """
      )
      
      # run
      GaussDrive.run("$(name).gjf")

      # result
      λ = GaussDrive.get("$(name).out", r" Excited State   1:.*eV\s*(?<target>[+-]?\d+(?:\.\d+)?)\s*nm.*\r")
      println("$(name).out > ", λ, " nm")
      global results[atom,method,basis] =  λ
      
    end
  end

  global text *= "$basis,\n"
  global text *= string([",$method" for method in methods]...) * "\n"
  for atom in atoms
    global text *= "$atom"
    for method in methods
      global text *= ",$(results[atom,method,basis])"
    end
    global text *= "\n"
  end
  println(text)

end

GaussDrive.write("./results.csv", text)

