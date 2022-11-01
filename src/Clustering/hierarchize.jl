function hierarchize(ro_x_co_x_nu, di = Euclidean(), li = :ward)

    hclust(pairwise(di, ro_x_co_x_nu, dims = 1), linkage = li)

end
