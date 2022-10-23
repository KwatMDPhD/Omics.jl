function move(pa1, pa2; ke_ar...)

    sp1_ = splitpath(pa1)

    sp2_ = splitpath(pa2)

    n_sk = length(OnePiece.Vector.get_common_start([sp1_, sp2_]))

    println("$(shorten(pa1, length(sp1_) - n_sk)) ==> $(shorten(pa2, length(sp2_) - n_sk))")

    mv(pa1, pa2; ke_ar...)

end
