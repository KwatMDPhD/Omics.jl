function cluster(ma, n_gr; ke_ar...)

    cutree(_hierarchize(ma; ke_ar...), k = n_gr)

end
