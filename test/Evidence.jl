using Test: @test

using Nucleus

# ---- #

using GLM: fitted

using DataFrames: completecases, disallowmissing!

# ---- #

for (id, ta_, f1_) in (
    (1, [0, 0, 0, 1, 1, 1], [0, 0, 0, 1, 1, 1]),
    (2, [1, 1, 1, 0, 0, 0], [1, 1, 1, 0, 0, 0]),
    (3, [0, 0, 0, 1, 1, 1], [1, 1, 1, 0, 0, 0]),
    (4, [1, 1, 1, 0, 0, 0], [0, 0, 0, 1, 1, 1]),
    (5, [0, 1, 0, 1, 0, 1], [0, 1, 0, 1, 0, 1]),
    (6, [0, 1, 0, 1, 0, 1], [1, 0, 1, 0, 1, 0]),
)

    ge = Nucleus.Evidence.fit(ta_, f1_)

    @test isapprox(fitted(ge), ta_; rtol = 1e-7)

    Nucleus.Evidence.plot(
        joinpath(Nucleus.TE, "$id.html"),
        "Sample",
        ["_$id" for id in eachindex(ta_)],
        "Target",
        ta_,
        "Feature",
        f1_,
        ge;
        marker_size = 40,
    )

    # 22.125 μs (209 allocations: 13.89 KiB)
    # 22.041 μs (209 allocations: 13.89 KiB)
    # 21.875 μs (209 allocations: 13.89 KiB)
    # 21.917 μs (209 allocations: 13.89 KiB)
    # 22.084 μs (209 allocations: 13.89 KiB)
    # 22.083 μs (209 allocations: 13.89 KiB)
    #@btime Nucleus.Evidence.fit($ta_, $f1_)

end

# ---- #

for (id, ta_, f1_) in (
    (7, vcat(fill(0, 50), fill(1, 50)), collect(1:100)),
    (8, vcat(fill(0, 50), fill(1, 50)), randn(100)),
)

    ge = Nucleus.Evidence.fit(ta_, f1_)

    Nucleus.Evidence.plot(
        joinpath(Nucleus.TE, "$id.html"),
        "Sample",
        ["_$id" for id in eachindex(ta_)],
        "Target",
        ta_,
        "Feature",
        f1_,
        ge;
    )

    # 67.667 μs (245 allocations: 30.38 KiB)
    # 20.250 μs (154 allocations: 24.24 KiB)
    #@btime Nucleus.Evidence.fit($ta_, $f1_)

end

# ---- #

da = Nucleus.DataFrame.read(
    joinpath(Nucleus._DA, "DataFrame", "titanic.tsv");
    select = ["name", "survived", "sex", "age", "pclass", "fare"],
    missingstring = ["NA"],
)

# ---- #

da = disallowmissing!(da[completecases(da), :])

# ---- #

ns = "Passenger"

# ---- #

sa_ = ["$(da[id, "name"]) ($id)" for id in axes(da, 1)]

# ---- #

nt = "Survival"

# ---- #

ta_ = da[!, "survived"]

# ---- #

nf_ = ["Sex", "Age", "Class", "Fare"]

# ---- #

fs = Matrix{Float64}(undef, lastindex(nf_), lastindex(sa_))

# ---- #

fs[1, :] = replace(da[!, "sex"], "female" => 0, "male" => 1)

# ---- #

fs[2, :] = da[!, "age"]

# ---- #

fs[3, :] = [4 - parse(Int, da[id, "pclass"][1]) for id in eachindex(sa_)]

# ---- #

fs[4, :] = da[!, "fare"]

# ---- #

ts = Nucleus.Match.make(
    Nucleus.TE,
    Nucleus.Information.get_information_coefficient,
    ns,
    sa_,
    nt,
    ta_,
    "Feature",
    nf_,
    fs;
)

# ---- #

for id in 1:4

    Nucleus.Evidence.plot(
        joinpath(Nucleus.TE, "$(nf_[id]).html"),
        ns,
        sa_,
        nt,
        ta_,
        nf_[id],
        fs[id, :],
        Nucleus.Evidence.fit(ta_, fs[id, :]);
    )

end
