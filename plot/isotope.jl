# using Pkg
# Pkg.add("Plots")
# Pkg.add("Antique")
using Plots
using Antique

for m in [1, 2]
  HO = HarmonicOscillator(k=1.0, m=m, ℏ=1.0)

  # 軸ラベル, 描写範囲, 凡例位置
  plot(xlabel="x", ylabel="V(x)", xlims=(-3.6,3.6), ylims=(0.0,3.2), legend=:bottomright, size=(450,400))

  # ポテンシャル
  plot!(-3:0.02:3, x->V(HO,x), label="", lc="#000000", lw=2)

  for i in 0:2
      # エネルギー（破線）
      hline!([E(HO,n=i)], label="", lc="#000000", ls=:dash)
      # エネルギー（実線）
      plot!([-sqrt(2/HO.k*E(HO,n=i)), sqrt(2/HO.k*E(HO,n=i))], fill(E(HO,n=i),2), label="", lc="#000000", lw=2)
      # 波動関数
      plot!(-3.5:0.02:3.5, x->0.5*ψ(HO,x,n=i)+E(HO,n=i), lc=i+1, lw=2, label="") # "n=$i")
  end

  savefig(PROGRAM_FILE * "_m=$(m).svg")
end