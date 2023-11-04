using Test: @test

using Nucleus

# ---- #

@test Nucleus.Error.@is Nucleus.TimeXSample._expand([1, 0], [1.0; 2;;])

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

    ex_, ex_x_sa_x_fl = Nucleus.TimeXSample._expand(ti_, ti_x_sa_x_nu)

    @test eltype(ex_x_sa_x_fl) == Float64

    @test ex_ == vcat(ti_, re[1])

    @test ex_x_sa_x_fl == vcat(ti_x_sa_x_nu, re[2])

    # 229.858 ns (7 allocations: 816 bytes)
    #@btime Nucleus.TimeXSample._expand($ti_, $ti_x_sa_x_nu)

end

# ---- #

for (ti_, sa_, ti_x_sa_x_nu) in ((
    [-1, 0, 1, 7],
    ["Aa", "Bb"],
    [
        -2.0 -3
        2 3
        4 9
        8 27
    ],
),)

    Nucleus.TimeXSample.write(Nucleus.TE, ti_, sa_, ti_x_sa_x_nu)

end

# ---- #

for na in ("change_time.html", "time_x_sample_x_number.tsv", "time_x_sample_x_number.html")

    @test isfile(joinpath(Nucleus.TE, na))

end
