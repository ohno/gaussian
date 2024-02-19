
# using Pkg
# Pkg.add("Plots")
# Pkg.add("Optim")
using Plots
using Optim
using SpecialFunctions

# https://doi.org/10.1021/acs.jchemed.8b00959

STO1G = [
0.270900 1.0
]

STO2G = [
0.151623 0.678914
0.851819 0.430129
]

STO3G = [
0.109818 0.444635
0.405771 0.535328
2.227660 0.154329
]

STO4G = [
0.0880187 0.291626
0.265204 0.532846
0.954620 0.260141
5.21686 0.0567523
]

STO5G = [
0.0744527 0.193572
0.197572 0.482570
0.578648 0.331816
2.07173 0.113541
11.3056 0.0221406
]

STO6G = [
0.0651095 0.130334
0.158088 0.416491
0.407099 0.370563
1.18506 0.168538
4.23592 0.0493615
23.1030 0.00916360
]

STONG = [STO1G, STO2G, STO3G, STO4G, STO5G, STO6G]

function EE(α, C)
    fact(n) = n>0 ? n*ffact(n-1) : 1 #factorial(n)
    ffact(n) = n>0 ? n*ffact(n-2) : 1
    n_max = length(α)
    H = zeros(n_max, n_max)
    T = zeros(n_max, n_max)
    V = zeros(n_max, n_max)
    S = zeros(n_max, n_max)
    l = 0
    mu = 1.0
    charge = [+1,-1]
    nu = α
    sum = 0.0
    for i in 1:n_max
        for j in 1:n_max
            S[i,j] = (2*sqrt(nu[i]*nu[j]) / (nu[i]+nu[j])) ^ (l+3/2)                            # 1d0/(nu(i)+nu(j)))は先に計算してもよい
            T[i,j] = 1/mu * (2*l+3)*nu[i]*nu[j] / (nu[i]+nu[j]) * S[i,j]                        # 換算質量はここにしか登場しない
            V[i,j] = (*(charge...)) * 2^(l+1)*fact(l) / (sqrt(pi)*ffact(2*l+1)) * sqrt(nu[i]+nu[j]) * S[i,j]    # クーロンポテンシャルの場合 かつ l=0の場合 farc(2**l*l) / fact(fact(2*l+1)) = 1/1 とした. 数式(16)には-2^(l+1)が抜けてる？
            H[i,j] = T[i,j] + V[i,j]
        end
    end
    return transpose(C) * H * C
end

# https://doi.org/10.1021/acs.jchemed.8b00959

EE(α::Float64) = α<0 ? NaN : 3/2*α - 2*sqrt(2*α/pi)
SS(α::Float64) = α<0 ? NaN : 4*(2*α)^(3/4)/pi^(1/4) * (sqrt(pi) * (2*α+1) * exp(1/(4*α)) * erfc(1/(2*sqrt(α))) -2*sqrt(α)) / (8*α^(5/2))
SS(α::Vector{Float64}, C::Vector{Float64}) = sum(C .* SS.(α))

α0 = [2.0]
res = optimize(α -> -SS(α[1]), α0, method=GradientDescent())
α = Optim.minimizer(res)

println("\tα\t\t\tS(α)")
println("STO-1G\t", α[1], "\t", EE(α[1]), "\t", SS(α[1]))
println("Ref\t", 0.270900, "\t\t\t", -0.424217, "\t\t", 0.978404) # SI, https://doi.org/10.1021/acs.jchemed.8b00959
println("var-1G\t", 8/(9*pi), "\t", EE(8/(9*pi)), "\t", SS(8/(9*pi)))

println("Calc\t\t\tRef\t\tS")
println(EE(STO1G[:,1], STO1G[:,2]), "\t", -0.424217, "\t", SS(STO1G[:,1], STO1G[:,2]))
println(EE(STO2G[:,1], STO2G[:,2]), "\t", -0.481156, "\t", SS(STO2G[:,1], STO2G[:,2]))
println(EE(STO3G[:,1], STO3G[:,2]), "\t", -0.494908, "\t", SS(STO3G[:,1], STO3G[:,2]))
println(EE(STO4G[:,1], STO4G[:,2]), "\t", -0.498481, "\t", SS(STO4G[:,1], STO4G[:,2]))
println(EE(STO5G[:,1], STO5G[:,2]), "\t", -0.499505, "\t", SS(STO5G[:,1], STO5G[:,2]))
println(EE(STO6G[:,1], STO6G[:,2]), "\t", -0.499826, "\t", SS(STO6G[:,1], STO6G[:,2]))

exact(r) = 1/sqrt(pi)*exp(-r)
STOnG(r, α, C) = sum(C .* (2*α./pi).^(3/4) .* exp.(-α.*r^2))

plot(xlims=(0,3), xlabel="\$r\$", ylabel="\$\\psi_{1s}(r)\$", size=(500,400))
plot!(0:0.01:3, r->STOnG(r,STO1G[:,1],STO1G[:,2]),   label="STO-1G  -0.424217")
plot!(0:0.01:3, r->STOnG(r,STO2G[:,1],STO2G[:,2]),   label="STO-2G  -0.481156")
plot!(0:0.01:3, r->STOnG(r,STO3G[:,1],STO3G[:,2]),   label="STO-3G  -0.494908")
plot!(0:0.01:3, r->STOnG(r,STO4G[:,1],STO4G[:,2]),   label="STO-4G  -0.498481")
plot!(0:0.01:3, r->STOnG(r,STO5G[:,1],STO5G[:,2]),   label="STO-5G  -0.499505")
plot!(0:0.01:3, r->STOnG(r,STO6G[:,1],STO6G[:,2]),   label="STO-6G  -0.499826")
plot!(0:0.01:3, r->exact(r), lc="#000000", ls=:dash, label="exact      -0.500000")

savefig(PROGRAM_FILE * ".svg")
