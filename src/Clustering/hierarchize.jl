function hierarchize(ro_x_co_x_nu; fu = Euclidean(), di = 2, li = :ward)

    return hclust(pairwise(fu, ro_x_co_x_nu; dims = di); linkage = li)

end
