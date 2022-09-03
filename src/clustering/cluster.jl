function cluster(sa_x_fe_x_nu, n_cl = 1; di = Euclidean(), li = :ward)

    sa_x_sa_x_di = pairwise(di, sa_x_fe_x_nu, dims = 1)

    cl = hclust(sa_x_sa_x_di, linkage = li)

    cl.order, cutree(cl, k = n_cl)

end
