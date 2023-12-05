using Test: @test

using Nucleus

# ---- #

for po in 0:7

    nu_ = randn(10^po)

    # TODO: Test.
    @info Nucleus.Density.get_bandwidth(nu_)

    # 3.333 ns (0 allocations: 0 bytes)
    # 145.461 ns (3 allocations: 304 bytes)
    # 688.490 ns (3 allocations: 1.03 KiB)
    # 6.600 μs (3 allocations: 8.09 KiB)
    # 270.125 μs (4 allocations: 78.33 KiB)
    # 3.682 ms (4 allocations: 781.45 KiB)
    # 42.729 ms (4 allocations: 7.63 MiB)
    # 498.138 ms (4 allocations: 76.29 MiB)
    #@btime Nucleus.Density.get_bandwidth($nu_)

end

# ---- #

const NU_ = [1, 2, 3, 4, 5, 6]

# ---- #

for (nu1_, nu2_) in (
    (NU_, NU_),
    ([2^po for po in NU_], NU_),
    (NU_[end:-1:1], NU_),
    ([2^po for po in NU_[end:-1:1]], NU_),
)

    de = Nucleus.Density.estimate((nu2_, nu1_); npoints = (8, 16))
    @info "Density" de.density collect(de.x) collect(de.y)

    Nucleus.Plot.plot_heat_map(
        "",
        permutedims(de.density);
        y = string.('*', de.y),
        x = string.('*', de.x),
        layout = Dict(
            "height" => 1000,
            "width" => 1100,
            "title" => Dict("text" => "$(join(zip(nu2_, nu1_), " "))"),
            "yaxis" => Dict("title" => Dict("text" => "Y (top to bottom)"), "dtick" => 2),
            "xaxis" => Dict("title" => Dict("text" => "X (left to right)"), "dtick" => 2),
        ),
    )

end
