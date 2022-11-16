function cluster(ro_x_co_x_nu, n)

end

function cluster(hi::Hclust, n)

    cutree(hi, k = n)

end
