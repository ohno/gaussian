# using Pkg
# Pkg.add("Plots")
# Pkg.add("SpecialPolynomials")
using Plots
using SpecialPolynomials

function psi(x,n,k,m)
    hbar = 1
    omega = sqrt(k/m) # mu = 1 / (1/m1 + 1/m2)
    A = sqrt(1/(factorial(n)*2^n)*sqrt(m*omega/(pi*hbar)))
    xi = sqrt(m*omega/hbar) * x
    return A*SpecialPolynomials.basis(Hermite, n)(xi)*exp(-xi^2/2)
end

function E_harmonic(n,k,m)
    hbar = 1
    omega = sqrt(k/m)
    return hbar*omega*(n+1/2)
end

V(x) = 1/2*k*x^2

k = 1.0
m = 1/(1/1 + 1/1)

plot(xlabel="x", ylabel="V(x)", xlims=(-4.7,4.7), ylims=(0,4.7), legend=:bottomright, size=(450,400))
plot!(-3:0.02:3, x->V(x), label="", lc="#000000", lw=2)

for i in 0:2
    # エネルギーを表す破線
    plot!([-sqrt(2/k*E_harmonic(i,k,m)), -4.0              ], fill(E_harmonic(i,k,m),2), label="", lc="#000000", ls=:dash)
    plot!([-sqrt(2/k*E_harmonic(i,k,m)), sqrt(2/k*E_harmonic(i,k,m))], fill(E_harmonic(i,k,m),2), label="", lc="#000000", lw=2)
    plot!([4                  , sqrt(2/k*E_harmonic(i,k,m))], fill(E_harmonic(i,k,m),2), label="", lc="#000000", ls=:dash)
    # 波動関数の描写
    plot!(-4.7:0.02:4.7, x->0.65*psi(x,i,k,m)+E_harmonic(i,k,m), label="n=$i", lc=i+1, lw=2)
end

savefig(PROGRAM_FILE * "_1.svg")

plot!() |> display

k = 1.0
m = 1/(1/2 + 1/2)

plot(xlabel="x", ylabel="V(x)", xlims=(-4.7,4.7), ylims=(0,4.5), legend=:bottomright, size=(450,400))
plot!(-3:0.02:3, x->V(x), label="", lc="#000000", lw=2)

for i in 0:2
    # エネルギーを表す破線
    plot!([-sqrt(2/k*E_harmonic(i,k,m)), -4.0              ], fill(E_harmonic(i,k,m),2), label="", lc="#000000", ls=:dash)
    plot!([-sqrt(2/k*E_harmonic(i,k,m)), sqrt(2/k*E_harmonic(i,k,m))], fill(E_harmonic(i,k,m),2), label="", lc="#000000", lw=2)
    plot!([4                  , sqrt(2/k*E_harmonic(i,k,m))], fill(E_harmonic(i,k,m),2), label="", lc="#000000", ls=:dash)
    # 波動関数の描写
    plot!(-4.7:0.02:4.7, x->0.65*psi(x,i,k,m)+E_harmonic(i,k,m), label="n=$i", lc=i+1, lw=2)
end

savefig(PROGRAM_FILE * "_2.svg")
