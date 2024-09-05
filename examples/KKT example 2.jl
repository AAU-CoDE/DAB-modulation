
using Symbolics, Groebner

# Khan Academy: Finishing the intro lagrange multiplier example
# https://www.khanacademy.org/math/multivariable-calculus/applications-of-multivariable-derivatives/lagrange-multipliers-and-constrained-optimization/v/lagrange-multipliers-using-tangency-to-solve-constrained-optimization

@variables x, y, λ

# maximise f subject to g
f = x^2*y
g = x^2 + y^2 - 1

L = f - λ*g

∇(f) = Symbolics.gradient(f, [x, y])

symbolic_solve([∇(L); g], [x, y, λ])
