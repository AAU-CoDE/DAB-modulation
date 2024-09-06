
include("DAB.jl")
using .DAB
using Symbolics, Groebner

@variables N, V₁, V₂, L, Tsw
@variables Δt₁, Δt₂, Δt₃, Δt₄, Δt₅, Δt₆, Δt₇, Δt₈

params = (L = L, N = N, V₁ = V₁, V₂ = V₂, Tsw = Tsw)
d, constr = dab_mode(params, mode_A)

power(Δts...) = solve_mode(d,Δts)[1]
i_rms(Δts...) = solve_mode(d,Δts)[2]
il_t(Δts...) = solve_mode(d,Δts)[3]
vts(Δts...) = solve_mode(d,Δts)[4]

Δts = (Δt₁, Δt₂, Δt₃, Δt₄, Δt₅, Δt₆, Δt₇, Δt₈)
p_sym = power(Δts...)
iL_rms = i_rms(Δts...)
t_sym,iL_sym = il_t(Δts...)
(vtA, vtB, vtC, vtD) = vts(Δts...)

## find optimum solution

@variables λ₁, λ₂, λ₃, λ₄

x = [Δt₁, Δt₂, Δt₃, Δt₄, Δt₅, Δt₆, Δt₇, Δt₈]
λ = [λ₁, λ₂, λ₃, λ₄]

∇(f) = Symbolics.gradient(f,x)

@variables P

# Lagrange multiplier

f = iL_rms # minimise root-mean-square inductor current
g₁ = p_sym - P # power constraint
g₂ = Δt₁ + Δt₂ + Δt₃ + Δt₄ + Δt₅ + Δt₆ + Δt₇ + Δt₈ - 1 # sum of time segments == 1 (Tsw)
g₃ = vtA - vtB # primary volt-second balance
g₄ = vtC - vtD # secondary volt-second balance
ℒ = f + λ₁*g₁ + λ₂*g₂ + λ₃*g₃ + λ₄*g₄
eqns = [∇(ℒ); g₁; g₂; g₃; g₄]

sol = symbolic_solve(eqns, [x..., λ...])
