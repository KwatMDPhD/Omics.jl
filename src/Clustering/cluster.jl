function cluster(hi::Hclust, n)

    return cutree(hi; k = n)

end
