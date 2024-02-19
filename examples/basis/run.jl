# using Pkg
# Pkg.add("Markdown")

# packages
using Markdown
using Printf
include("../GaussDrive.jl")
cd(dirname(@__FILE__))

# H

for method in ["HF"]
  for basis in ["STO-3G" "3-21G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31G(3df,3pd)" "6-311G" "6-311G(3df,3pd)" "cc-pVDZ" "cc-pVTZ" "cc-pVQZ" "cc-pV5Z" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ" "aug-cc-pV5Z" "EPR-II" "EPR-III"]

      # file name
      name = "./H/$(method)/$(basis)"

      # generating input file
      GaussDrive.write("$(name).gjf", 
          """# $(method)/$(basis)

          H

          0 2
          H 0.0 0.0 0.0


          """
      )

      # run
      GaussDrive.run("$(name).gjf")
      
  end

  # make table
  GaussDrive.table("./H/$(method)/", sort=false) |> Markdown.parse |> display

end

# H2

for method in ["HF"]
    for basis in ["STO-3G" "3-21G" "4-31G" "6-31G" "6-31G(d)" "6-31G(d,p)" "6-31G(3df,3pd)" "6-311G" "6-311G(3df,3pd)" "cc-pVDZ" "cc-pVTZ" "cc-pVQZ" "cc-pV5Z" "aug-cc-pVDZ" "aug-cc-pVTZ" "aug-cc-pVQZ" "aug-cc-pV5Z" "EPR-II" "EPR-III"]
  
        # file name
        name = "./H2/$(method)/$(basis)"
  
        # generating input file
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
        
    end
  
    # make table
    GaussDrive.table("./H/$(method)/", sort=false) |> Markdown.parse |> display

end
