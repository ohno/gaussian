E_best = -1.174475714138 # https://doi.org/10.1103/PhysRevA.72.062502
E_HF = -1.133629573 # https://doi.org/10.1016/0009-2614(88)85022-X
E_corr = E_HF - E_best

println("E_corr = ")
println(E_corr, " E_h")
println(E_corr*27.21138, " eV")
println(E_corr*627.5095 , " kcal/mol")

energy = [
-0.976189542
-1.098820632
-1.123021278
-1.127152964
-1.12814414
-1.12844178
-1.128511869
-1.128532152
-1.128538849
-1.128540755
-1.128541875
-1.128542219
-1.12854231
-1.128542335
-1.128542342
-1.128542346
-1.128542348
-1.128542349
-1.128542349
-1.128542349
-1.128542349
-1.13357232
-1.133628675
-1.133629552
-1.133629571
-1.133629571
-1.133629573
]

basis = [
"(1s)"
"(2s)"
"(3s)"
"(4s)"
"(5s)"
"(6s)"
"(7s)"
"(8s)"
"(9s)"
"(10s)"
"(11s)"
"(12s)"
"(13s)"
"(14s)"
"(15s)"
"(16s)"
"(17s)"
"(18s)"
"(19s)"
"(20s)"
"(21s)"
"(21s,9p)"
"(22s,11p,6d)"
"(22s,13p,8d,4f)"
"(22s,13p,8d,4f,2g)"
"(22s,13p,8d,4f,2g,2h)"
"HF limit"
]

# using Pkg
# Pkg.add("Plots")
using Plots

plot(framestyle=:origin, grid=false, tick_direction=:out)
plot!([0,0], [-1.18, -1.09], label="", lc="#24292E", lw=0, arrow=(:closed, 2.0))
plot!([0,0], [-1.18, -1.092], label="", lc="#24292E", lw=2)

plot!(energy, ylims=(-1.18, -1.09), label="", lw=2, lc="#CFDFF4", markercolors="#2962AD", markershape = :circle, markersize=3, msw=0)
plot!(x->E_best, label="", lw=2, lc="#2962AD", ls=:dash)

plot!([27,27], [E_HF-0.002, E_best+0.001], label="", lc="#24292E", lw=0, arrow=(:closed, 2.0))
plot!([27,27], [E_best+0.001, E_HF-0.002], label="", lc="#24292E", lw=0, arrow=(:closed, 2.0))
plot!([27,27], [E_best+0.003, E_HF-0.004], label="", lc="#24292E", lw=2)

for i in 1:length(energy)
    plot!(annotations=(i, energy[i]+0.002, (basis[i], 8, 90.0, :left)))
end

savefig(PROGRAM_FILE * ".svg")
