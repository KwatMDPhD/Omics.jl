function move(pa1, pa2; n_ba = 0, fo = false)

    sp1_ = splitpath(pa1)

    sp2_ = splitpath(pa2)

    n_sk = length(get_longest_common_prefix([sp1_, sp2_])) - n_ba

    println(joinpath(sp1_[n_sk:end]...), " ==> ", joinpath(sp2_[n_sk:end]...))

    return mv(pa1, pa2; force = fo)

end
