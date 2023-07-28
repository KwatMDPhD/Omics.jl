using Test: @test

using BioLab

# ---- #

for (an_, re) in (
    ((1, 2, 2, 3, 3, 3, 4), Dict(1 => 1, 2 => 2, 3 => 3, 4 => 1)),
    (('a', 'b', 'b', 'c', 'c', 'c', 'd'), Dict('a' => 1, 'b' => 2, 'c' => 3, 'd' => 1)),
)

    @test BioLab.Collection.count_sort(an_) == re

end
