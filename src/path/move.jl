function move(pa1, pa2; n_ba = 0, ke_ar...)

    sp1_ = splitpath(pa1)

    sp2_ = splitpath(pa2)

    n_sk = length(OnePiece.vector.get_longest_common_prefix(sp1_, sp2_)) - n_ba

    println("$(shorten(sp1_, length(sp1_) - n_sk)) ==> $(shorten(sp2_, length(sp2_) - n_sk))")

    mv(pa1, pa2; ke_ar...)

end
