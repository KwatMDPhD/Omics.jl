module Information

function get_kullback_leibler_divergence(n1, n2)

    n1 * log2(n1 / n2)

end

function get_thermodynamic_depth(n1, n2)

    get_kullback_leibler_divergence(n1, n2) - get_kullback_leibler_divergence(n2, n1)

end

function get_thermodynamic_breadth(n1, n2)

    get_kullback_leibler_divergence(n1, n2) + get_kullback_leibler_divergence(n2, n1)

end

function get_antisymmetric_kullback_leibler_divergence(n1, n2, n3, n4 = n3)

    get_kullback_leibler_divergence(n1, n3) - get_kullback_leibler_divergence(n2, n4)

end

function get_symmetric_kullback_leibler_divergence(n1, n2, n3, n4 = n3)

    get_kullback_leibler_divergence(n1, n3) + get_kullback_leibler_divergence(n2, n4)

end

end
