include("environment.jl")

# ---- #

for (ar1, ar2) in (([], ()), ([1, 2], [""]), ([3 4], ["a", "b"]))

    @test @is_error BioLab.Array.error_size_difference(ar1, ar2)

end

# ---- #

for ar_ in (([], []), ([1, 2], ["", "a"]), ([3, 4], ["b", "c"], ['d', 'e']), ([], [], []))

    BioLab.Array.error_size_difference(ar_)

end

# ---- #

for an_ in ([1.0, 1, 2.0], [1 1 2], ["a", "a", "b"], [1 2.0; 2 3])

    @test @is_error BioLab.Array.error_duplicate(an_)

end

# ---- #

for an_ in ((), [], [1, 2, 3], ['a', 'b', 'c'], [1 2; 3 4])

    BioLab.Array.error_duplicate(an_)

end
