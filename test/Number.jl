include("_.jl")

# ---- #

for nu in (-0, 0, -0.0, 0.0, 1 / 3, 0.1234567890123456789, 0.001, 0.000001)

    BioLab.print_header(nu)

    # TODO: `@test`.
    display(BioLab.Number.format(nu))

    # @code_warntype BioLab.Number.format(nu)

    # 91.048 ns (2 allocations: 432 bytes)
    # 91.055 ns (2 allocations: 432 bytes)
    # 89.770 ns (2 allocations: 432 bytes)
    # 89.734 ns (2 allocations: 432 bytes)
    # 113.063 ns (2 allocations: 432 bytes)
    # 118.540 ns (2 allocations: 432 bytes)
    # 111.486 ns (2 allocations: 432 bytes)
    # 178.837 ns (2 allocations: 432 bytes)
    # @btime BioLab.Number.format($nu)

end

# ---- #

for it in 0:28

    # TODO: `@test`.
    display(BioLab.Number.rank_in_fraction(it))

end

for it in (0, 7, 17)

    BioLab.print_header(it)

    # @code_warntype BioLab.Number.rank_in_fraction(it)

    # 24.096 ns (0 allocations: 0 bytes)
    # 24.054 ns (0 allocations: 0 bytes)    
    # 30.905 ns (0 allocations: 0 bytes)    
    # @btime BioLab.Number.rank_in_fraction($it)

end
