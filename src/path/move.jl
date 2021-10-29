using ..vector: get_longest_common_prefix

function move(
    pa1::String,
    pa2::String;
    n_ba::Int64 = 1,
    te::Bool = false,
    fo::Bool = false,
)::String

    sp1_ = splitpath(pa1)

    sp2_ = splitpath(pa2)

    n_sk = length(get_longest_common_prefix([sp1_, sp2_])) - n_ba

    println(joinpath(sp1_[n_sk:end]...), " ==> ", joinpath(sp2_[n_sk:end]...))

    if te

        return ""

    else

        return mv(pa1, pa2; force = fo)

    end

end

export move
