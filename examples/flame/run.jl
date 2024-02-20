# using Pkg
# Pkg.add("Markdown")

# packages
using Markdown
using Printf
include("../GaussDrive.jl")
cd(dirname(@__FILE__))

# configuration

for method in ["UCIS" "UCIS(D)" "UHF" "UB3LYP" ["CASSCF(1,$(i),NRoot=2)" for i in 1:8]...]
  for basis in ["6-311G(3df,3pd)"]
      
      # file name
      name = method∈["HF" "UHF" "B3LYP" "UB3LYP" ] ? "./TD$(method)" : "./$(method)"

      # file name
      GaussDrive.write("$(name).gjf", 
          """# $(method)/$(basis) $(method∈["HF" "UHF" "B3LYP" "UB3LYP"] ? "TD" : "")

          Li

          0 2
          Li  0.0  0.0  0.0


          """
      )
      
      # run
      GaussDrive.run("$(name).gjf")

  end
end

# make table
GaussDrive.table("./", sort=false) |> Markdown.parse |> display
