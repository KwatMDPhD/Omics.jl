function move(paf, pat; ke_ar...)

    spf_ = splitpath(paf)

    spt_ = splitpath(pat)

    n = length(BioinformaticsCore.Vector.get_common_start((spf_, spt_)))

    println("$(shorten(paf, length(spf_) - n)) ==> $(shorten(pat, length(spt_) - n))")

    mv(paf, pat; ke_ar...)

end
