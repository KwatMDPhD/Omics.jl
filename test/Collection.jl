using Test: @test

using BioLab

# ---- #

const IT_ = collect(-1:9)

const FL_ = convert(Vector{Float64}, IT_)

for (n, re) in ((2, [-1, 9]), (3, [-1, 4, 9]), (5, [-1, 1.5, 4, 6.5, 9]), (11, FL_))

    @test BioLab.Collection.range(IT_, n) === -1:9

    @test collect(BioLab.Collection.range(vcat(NaN, FL_), n)) == re

end

# ---- #

for (an_, re) in (
    ((1, 2, 2, 3, 3, 3, 4), Dict(1 => 1, 2 => 2, 3 => 3, 4 => 1)),
    (('a', 'b', 'b', 'c', 'c', 'c', 'd'), Dict('a' => 1, 'b' => 2, 'c' => 3, 'd' => 1)),
    (('c', 'c', 'c', 'b', 'b', 'a'), Dict('a' => 1, 'b' => 2, 'c' => 3)),
)

    @test BioLab.Collection.unique_sort(an_) == sort!(collect(keys(re)))

    @test BioLab.Collection.count_sort(an_) == re

    println(BioLab.Collection.count_sort_string(an_, 2))

end

# ---- #

@test BioLab.Error.@is BioLab.Collection.map_index(['a', 'b', 'b'])

# ---- #

for (an_, re) in (
    (('a', 'b', 'c'), Dict('a' => 1, 'b' => 2, 'c' => 3)),
    (('c', 'b', 'a'), Dict('a' => 3, 'b' => 2, 'c' => 1)),
)

    @test BioLab.Collection.map_index(an_) == re

end
