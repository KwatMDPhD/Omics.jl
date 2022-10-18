function _hierarchize(ma, di = Euclidean(), li = :ward)

    hclust(pairwise(di, ma, dims = 1), linkage = li)

end
