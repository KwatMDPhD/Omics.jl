using Test: @test

using Nucleus

# ---- #

c = Dict("a"=>1)

b = Dict("b"=>2, "c"=>c, "d"=>c)

Nucleus.Dict.merge(b, Dict("c"=>Dict("x"=>9)))

# ---- #

da = Nucleus.DataFrame.read(joinpath(Nucleus._DA, "DataFrame", "titanic.tsv"))

# ---- #

ns = "Passenger"

sa_ = ["$(da[id, "name"]) ($id)" for id in axes(da, 1)]

# ---- #

ta_ = da[!, "survived"]

# ---- #

fs = Matrix{Float64}(undef, 3, lastindex(ta_))

fs[1, :] = replace(da[!, "sex"], "female" => 0, "male" => 1)

# TODO: Remove "NA"s.

fs[2, :] = parse.(Float64, replace!(da[!, "age"], "NA" => "-1"))

fs[3, :] = parse.(Float64, replace!(da[!, "fare"], "NA" => "-1"))

# ---- #

ts = Nucleus.Match.make(
    Nucleus.TE,
    Nucleus.Information.get_information_coefficient,
    ns,
    sa_,
    "Survived",
    ta_,
    "Feature",
    ["Sex", "Age", "Fare"],
    fs;
    layout = Dict("title" => Dict("text" => "Match Panel")),
)

# ---- #

nx = ns

x = sa_

nb = "Survived"

bi_ = ta_

nn = "Age"

nu_ = fs[2, :]

i0_ = findall(iszero, bi_)

i1_ = findall(isone, bi_)

Nucleus.Plot.plot(
    joinpath(Nucleus.TE, "fit.html"),
    [
        Dict("name" => nn, "x" => x, "y" => nu_, "mode" => "markers"),
        Dict("name" => "!$nb", "x" => x[i0_], "y" => nu_[i0_], "mode" => "markers"),
        Dict("name" => nb, "x" => x[i1_], "y" => nu_[i1_], "mode" => "markers"),
    ],
    Dict(
        "title" => Dict("text" => "Fit"),
        "xaxis" => Dict("title" => Dict("text" => nx)),
        "yaxis" => Dict("title" => Dict("text" => nn)),
    ),
)
