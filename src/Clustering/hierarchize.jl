function hierarchize(ro_x_co_x_nu; di = Euclidean(), dm = 2, li = :ward)

    hclust(pairwise(di, ro_x_co_x_nu; dims = dm); linkage = li)

end
