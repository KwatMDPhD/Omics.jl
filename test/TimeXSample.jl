using Test: @test

using Nucleus

# ---- #

@test Nucleus.Error.@is Nucleus.TimeXSample.expand([1, 0], [1.0; 2;;])

# ---- #

for (ti_, ti_x_sa_x_nu, re...) in ((
    [-1, 0, 1, 7],
    [
        -2 -3
        2 3
        4 9
        8 27
    ],
    ["Maximum", "Sum", "Change", "Decrease", "Increase"],
    [
        8.0  27.0
        12.0  36.0
        10.0  30.0
        0.0   0.0
        10.0  30.0
    ],
),)

    ex_, ex_x_sa_x_fl = Nucleus.TimeXSample.expand(ti_, ti_x_sa_x_nu)

    @test eltype(ex_x_sa_x_fl) == Float64

    @test ex_ == vcat(ti_, re[1])

    @test ex_x_sa_x_fl == vcat(ti_x_sa_x_nu, re[2])

    # 228.906 ns (7 allocations: 816 bytes)
    #@btime Nucleus.TimeXSample.expand($ti_, $ti_x_sa_x_nu)

end
