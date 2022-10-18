function cluster(ma, n_gr, ar_...)

    cutree(_hierarchize(ma, ar_...), k = n_gr)

end
