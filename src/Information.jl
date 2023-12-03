module Information

# TODO: Improve bandwidth.
using KernelDensity: default_bandwidth, kde

using Statistics: cor

using ..Nucleus

@inline function get_kullback_leibler_divergence(nu1, nu2)

    nu1 * log(nu1 / nu2)

end

@inline function get_thermodynamic_depth(nu1, nu2)

    get_kullback_leibler_divergence(nu1, nu2) - get_kullback_leibler_divergence(nu2, nu1)

end

@inline function get_thermodynamic_breadth(nu1, nu2)

    get_kullback_leibler_divergence(nu1, nu2) + get_kullback_leibler_divergence(nu2, nu1)

end

@inline function get_antisymmetric_kullback_leibler_divergence(nu1, nu2, nu3, nu4 = nu3)

    get_kullback_leibler_divergence(nu1, nu3) - get_kullback_leibler_divergence(nu2, nu4)

end

@inline function get_symmetric_kullback_leibler_divergence(nu1, nu2, nu3, nu4 = nu3)

    get_kullback_leibler_divergence(nu1, nu3) + get_kullback_leibler_divergence(nu2, nu4)

end

@inline function get_entropy(nu)

    iszero(nu) ? 0.0 : -nu * log(nu)

end

@inline function normalize_mutual_information(mu, h1, h2)

    2mu / (h1 + h2)

end

function get_mutual_informationp(jo; no = false)

    p1_ = sum.(eachrow(jo))

    p2_ = sum.(eachcol(jo))

    mu = 0.0

    for (id2, p2) in enumerate(p2_), (id1, p1) in enumerate(p1_)

        pj = jo[id1, id2]

        if !iszero(pj)

            mu += get_kullback_leibler_divergence(pj, p1 * p2)

        end

    end

    if no

        normalize_mutual_information(mu, sum(get_entropy, p1_), sum(get_entropy, p2_))

    else

        mu

    end

end

@inline function _sum_get_entropy(ea)

    get_entropy(sum(ea))

end

function get_mutual_informatione(jo; no = false)

    h1 = sum(_sum_get_entropy, eachrow(jo))

    h2 = sum(_sum_get_entropy, eachcol(jo))

    mu = h1 + h2 - sum(get_entropy(pj) for pj in jo)

    if no

        normalize_mutual_information(mu, h1, h2)

    else

        mu

    end

end

function get_mutual_information(
    nu1_::AbstractVector{<:Integer},
    nu2_::AbstractVector{<:Integer};
    ke_ar...,
)

    get_mutual_informatione(Nucleus.Collection.count(nu1_, nu2_) / lastindex(nu1_); ke_ar...)

end

function get_mutual_information(nu1_, nu2_; ke_ar...)

    get_mutual_informatione(jo; ke_ar...)

end

function get_information_coefficient(nu1_, nu2_; fa = 0.75, np_ = (32, 32))

    co = cor(nu1_, nu2_)

    fa *= 1 - abs(co)

    b1 = default_bandwidth(nu1_) * fa

    b2 = default_bandwidth(nu2_) * fa

    bi = kde((nu2_, nu1_), npoints = np_; bandwidth = (b2, b1))

    gr1_ = collect(bi.y)

    gr2_ = collect(bi.x)

    de = bi.density

    d1 = (gr1_[end] - gr1_[1]) / np_[1]

    d2 = (gr2_[end] - gr2_[1]) / np_[2]

    Nucleus.Plot.plot_heat_map(
        "",
        de;
        y = gr1_,
        x = gr2_,
        nar = "D1 = $d1",
        nac = "D2 = $d2",
        layout = Dict("title" => Dict("text" => "Density<br>Sum = $(sum(de))")),
    )

    jo = de / (sum(de) * d1 * d2)

    Nucleus.Plot.plot_heat_map(
        "",
        jo;
        y = gr1_,
        x = gr2_,
        nar = "",
        nac = "",
        layout = Dict("title" => Dict("text" => "Probability<br>Sum = $(sum(jo))")),
    )

    p1_ = sum.(eachrow(jo)) * d2

    p2_ = sum.(eachcol(jo)) * d1

    Nucleus.Plot.plot_scatter(
        "",
        (p1_, p2_),
        (gr1_, gr2_);
        name_ = (sum(p1_), sum(p2_)),
        layout = Dict("title" => Dict("text" => "Marginal Probability")),
    )

    mu = 0.0

    for (id2, p2) in enumerate(p2_), (id1, p1) in enumerate(p1_)

        pj = jo[id1, id2]

        if !iszero(pj)

            mu += get_kullback_leibler_divergence(pj, p1 * p2)

        end

    end

    mu *= d1 * d2

    sign(co) * sqrt(1.0 - exp(-2mu))

end

end
