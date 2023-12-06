using Test: @test

using Nucleus

# ---- #

for po in 0:7

    nu_ = randn(10^po)

    # TODO: Test.
    @info Nucleus.Density.get_bandwidth(nu_)

    # 3.292 ns (0 allocations: 0 bytes)
    # 144.101 ns (3 allocations: 304 bytes)
    # 624.023 ns (3 allocations: 1.03 KiB)
    # 6.017 μs (3 allocations: 8.09 KiB)
    # 240.500 μs (4 allocations: 78.33 KiB)
    # 3.572 ms (4 allocations: 781.45 KiB)
    # 44.638 ms (4 allocations: 7.63 MiB)
    # 515.417 ms (4 allocations: 76.29 MiB)
    #@btime Nucleus.Density.get_bandwidth($nu_)

end

# ---- #

const NU_ = [1, 2, 3, 4, 5, 6]

# ---- #

for (nu1_, nu2_) in (
    (NU_, NU_),
    (NU_, [2^po for po in NU_]),
    (NU_, NU_[end:-1:1]),
    (NU_, [2^po for po in NU_[end:-1:1]]),
)

    ro_, co_, de = Nucleus.Density.estimate((nu1_, nu2_); npoints = (8, 16))

    # TODO: Test.
    @info "Density" ro_ co_ de

    Nucleus.Plot.plot_heat_map(
        "",
        de,
        y = Nucleus.Plot._label_row.(Nucleus.Number.format4.(ro_)),
        x = Nucleus.Plot._label_col.(Nucleus.Number.format4.(co_)),
        layout = Dict(
            "height" => 800,
            "width" => 960,
            "title" => Dict("text" => join(zip(nu1_, nu2_), " ")),
            "yaxis" => Dict("title" => Dict("text" => "← <b>$(lastindex(ro_))</b>")),
            "xaxis" => Dict("title" => Dict("text" => "<b>$(lastindex(co_))</b> →")),
        ),
    )

end
