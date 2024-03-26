# using Pkg
# Pkg.add("Plots")
using Plots

plot(framestyle=:none, grid=false, tick=:none, size=(570,480), xlims=(-2.5,15), ylims=(-1,16))
m1 = 1836.15267343
m2 = 206.7682830 #1836.15267343 #206.7682830 # 3670.48296788
mu = 1 / (1/m1 + 1/m2)

Re = 1.997193319969992
De = 0.6026346191065398 - 0.5
a = 0.9056744331168292

hbar = 1.0
k = 2*a^2*De
omega = sqrt(k/mu)
x = hbar*omega/(4*De)

morse(r) = De*( exp(-2*a*(r-Re)) -2*exp(-a*(r-Re)) ) -0.5
harmo(r) = 1/2 * k * (r-Re)^2 - De - 0.5

E_harmo(n) = - De + hbar*omega*(n+1/2) - 0.5
E_morse(n) = - De + hbar*omega*(n+1/2) - x*hbar*omega*(n+1/2)^2 - 0.5

x_min = -0.4
x_max = 6.5
y_min = -0.63
y_max = -0.4

plot(framestyle=:none, grid=false, tick=:none, size=(570,480))
plot!(xlims=(x_min,x_max), ylims=(y_min,y_max))
plot!(xlabel="", ylabel="")

plot!([x_min,x_max], fill(y_min+0.015,2), label="", lc="#24292E", lw=0, arrow=(:closed, 2.5))
plot!([x_min,x_max*0.985], fill(y_min+0.015,2), label="", lc="#24292E", lw=2.5)

plot!(zeros(2), [y_min,y_max], label="", lc="#24292E", lw=0, arrow=(:closed, 2.5))
plot!(zeros(2), [y_min,y_max-0.001], label="", lc="#24292E", lw=2.5)

plot!(-1:0.1:16, r->morse(r), label="", lc="#224466", lw=2.5)
# plot!(-1:0.1:16, r->harmo(r), label="", lc="#BC1C5F", lw=2.5)

plot!([Re,Re], [y_min+0.015, -De-0.5], label="", lc="#24292E", lw=2.5, ls=:dot)
plot!([0,Re], [-De-0.5, -De-0.5], label="", lc="#24292E", lw=2.5, ls=:dot)
scatter!([Re], [-De-0.5], label="", msw=0, mc="#224466")

energy = E_morse(0)
plot!(0.02:0.01:2, r->(morse(r)>energy ? energy : NaN), label="", lc="#24292E", lw=2.5, ls=:dot)

X = 1.4
plot!([X, X], [-De-0.5,energy], label="", lc="#24292E", lw=0, arrow=(:closed, 2.5))
plot!([X, X], [energy,-De-0.5], label="", lc="#24292E", lw=0, arrow=(:closed, 2.5))
plot!([X, X], [-De-0.5+0.01, energy-0.01], label="", lc="#24292E", lw=2.5)

for i in 0:6
#     energy = energy_harmo(i)
#     plot!(0.02:0.01:21, r->(harmo(r)<energy ? energy : NaN), label="", lc="#BC1C5F")
    energy = E_morse(i)
    plot!(0.02:0.01:21, r->(morse(r)<energy ? energy : NaN), label="", lc="#578FC7")
end

savefig(PROGRAM_FILE * ".svg")
