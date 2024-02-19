# using Pkg
# Pkg.add("Plots")
using Plots

plot(framestyle=:none, grid=false, tick=:none, size=(570,480), xlims=(-2.5,15), ylims=(-1,16))

plot!([-1,15], [0,0], label="", lc="#24292E", lw=0, arrow=(:closed, 2.0))
plot!([-1,14.9], [0,0], label="", lc="#24292E", lw=2.5)

plot!([0,0], [-1,16], label="", lc="#24292E", lw=0, arrow=(:closed, 2.0))
plot!([0,0], [-1,15.9], label="", lc="#24292E", lw=2.5)

plot!(annotations=(-2.5, 2.0, ("HF", 12, 0.0, :left)))
plot!(annotations=(-2.5, 4.0, ("CIS", 12, 0.0, :left)))
plot!(annotations=(-2.5, 6.0, ("CISD", 12, 0.0, :left)))
plot!(annotations=(-2.5, 8.0, ("CISDT", 12, 0.0, :left)))
plot!(annotations=(-2.5, 10.0, ("CISDTQ", 12, 0.0, :left)))
plot!(annotations=(-2.5, 12.0, ("...", 12, 0.0, :left)))
plot!(annotations=(-2.5, 14.0, ("Full CI", 12, 0.0, :left)))

plot!(annotations=(2.0, -1.0, ("SZ", 12, 0.0, :bottom)))
plot!(annotations=(4.0, -1.0, ("DZ", 12, 0.0, :bottom)))
plot!(annotations=(6.0, -1.0, ("TZ", 12, 0.0, :bottom)))
plot!(annotations=(8.0, -1.0, ("QZ", 12, 0.0, :bottom)))
plot!(annotations=(10.0, -1.0, ("5Z", 12, 0.0, :bottom)))
plot!(annotations=(12.0, -1.0, ("...", 12, 0.0, :bottom)))
plot!(annotations=(14.0, -1.0, ("HF limit", 12, 0.0, :bottom)))

plot!([1,13], [1,13], label="", lc="#24292E", lw=0, arrow=(:closed, 2.0))
plot!([1,12.9], [1,12.9], label="", lc="#24292E", lw=2.5)

plot!(annotations=(14.0, 14.0, ("Exact", 12, 0.0, :bottom)))

savefig(PROGRAM_FILE * ".svg")
