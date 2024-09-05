
using Symbolics, Groebner

# MIT OCW 2.853/2.854 KKT example
# https://ocw.mit.edu/courses/2-854-introduction-to-manufacturing-systems-fall-2016/6cbf08435a0e531bcfeb396636e216d5_MIT2_854F16_KktExample.pdf

@variables x1, x2, x3, x4, λ

# minimise f subject to g
f = x1^2 + x2^2 + x3^2 + x4^2
g = x1 + x2 + x3 + x4 - 1

L = f - λ*g

∇(f) = Symbolics.gradient(f, [x1, x2, x3, x4])

symbolic_solve([∇(L); g], [x1, x2, x3, x4, λ])
