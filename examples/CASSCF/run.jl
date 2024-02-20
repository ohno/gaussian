# using Pkg
# Pkg.add("Markdown")

# packages
using Markdown
using Printf
include("../GaussDrive.jl")
cd(dirname(@__FILE__))

# configuration

for method in ["CIS" "CIS(D)" "HF" "B3LYP" "CISD" ["CASSCF(2,$(i),NRoot=2)" for i in 2:10]...]
  for basis in ["6-31G(d,p)"]
      
      # file name
      name = method∈["HF" "UHF" "B3LYP" "UB3LYP" ] ? "./TD$(method)" : "./$(method)"

      # file name
      GaussDrive.write("$(name).gjf", 
          """# $(method∈["HF" "UHF" "B3LYP" "UB3LYP"] ? "TD" : "") $(method)/$(basis) units=au

          H2

          0  1
          H  0.0  0.0  0.0
          H  0.0  0.0  1.4


          """
      )
      
      # run
      GaussDrive.run("$(name).gjf")

  end
end

# make table
GaussDrive.table("./", sort=false) |> Markdown.parse |> display
