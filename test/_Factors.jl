using PGMs

using PGMs.Factors: @factor

using Test: @test

# ---- #

for ch in 'A':'C'

    eval(:(struct $(Symbol(ch)) end))

end

# ---- #

@macroexpand @factor function p!(a::A, c::B, b::C) end

@factor function p!(a::A, c::B, b::C) end

@test hasmethod(PGMs.Factors.p!, Tuple{A, B, C})
