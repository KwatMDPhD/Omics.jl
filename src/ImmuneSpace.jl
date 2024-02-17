module ImmuneSpace

using StatsBase: mean

using ..Nucleus

function read_demographic(di)

    _np, pa_, de_, pd = Nucleus.DataFrame.separate(joinpath(di, "demographics.tsv"); delim = '\t')

    dp = permutedims(pd)

    @info "👥 demographics" de_ pa_ dp

    de_, pa_, dp

end

function _shorten(fl::Real)

    isinteger(fl) ? convert(Int, fl) : fl

end

function _shorten(st)

    st[1:2]

end

# TODO: Remove elispot.
function read_function(di, pr)

    fu_, ti_, un_, pa_, mn_ = eachcol(
        Matrix(
            Nucleus.DataFrame.read(joinpath(di, "$pr.tsv"); delim = '\t')[
                !,
                [
                    pr == "elisa" || pr == "elispot" ? "Analyte" : "Virus",
                    "Study Time Collected",
                    "Study Time Collected Unit",
                    "Participant ID",
                    pr == "elispot" ? "Spot Number Reported" : "Value Preferred",
                ],
            ],
        ),
    )

    ft___, pa_, fp = Nucleus.Target.tabulate(
        (Nucleus.String.clean.(fu_), _shorten.(ti_), _shorten.(un_)),
        (pa_,),
        float.(replace(mn_, missing => NaN)),
    )

    ft_ = join.(ft___, ' ')

    # TODO
    fp .= log.(fp .+ 1)

    @info "🧫 $pr" ft_ pa_ fp

    ft_, pa_, fp

end

function read_rna(di, pr::AbstractString)

    _nr, rn_, sa_, rs = Nucleus.DataFrame.separate(joinpath(di, "$pr.tsv"))

    @info "🧬 $pr" rn_ sa_ rs

    rn_, sa_, rs

end

function read_rna(::Any, pr)

    pr

end

function read_rna_map(di)

    Dict(
        eachrow(
            Matrix(
                Nucleus.DataFrame.read(
                    joinpath(di, "FeatureAnnotation.tsv");
                    select = ["Feature Id", "Gene Symbol"],
                ),
            ),
        ),
    )

end

function _error_has_different_value(ke_va, ke, va)

    if haskey(ke_va, ke) && ke_va[ke] != va

        error("$ke => $(ke_va[ke]) (!= $va).")

    end

end

function _name(pa, ti, un)

    "$pa $(_shorten(ti)) $(_shorten(un))"

end

function read_sample_map(di, pr)

    na_sa = Dict{String, String}()

    for ro in eachrow(Nucleus.DataFrame.read(joinpath(di, "$pr.txt"); delim = '\t'))

        sa = _name(
            "$(ro["Subject Accession"]).$(ro["Study Accession"][4:end])",
            ro["Study Time Collected"],
            ro["Study Time Collected Unit"],
        )

        bi = ro["Biosample Accession"]

        ex = ro["Expsample Accession"]

        _error_has_different_value(na_sa, bi, sa)

        _error_has_different_value(na_sa, ex, sa)

        na_sa[bi] = sa

        na_sa[ex] = sa

    end

    na_sa

end

function name_sample(di, cf_, so)

    da = Nucleus.DataFrame.read(joinpath(di, "gene_expression_files.tsv"))

    da = da[[all(fu(ro[co]) for (co, fu) in cf_) for ro in eachrow(da)], :]

    if !isempty(so)

        sort!(da, so)

    end

    sa_ = Vector{String}(undef, size(da, 1))

    for (i1, (pa, ti, un, gs)) in enumerate(
        eachrow(
            Matrix(
                da[
                    !,
                    [
                        "Participant ID",
                        "Study Time Collected",
                        "Study Time Collected Unit",
                        "GEO accession",
                    ],
                ],
            ),
        ),
    )

        sa = _name(pa, ti, un)

        if !ismissing(gs)

            sa *= " $gs"

        end

        sa_[i1] = sa

    end

    sa_

end

function _get_difference(ro_, rc, ba_)

    nd = lastindex(ba_)

    di_ = Vector{String}(undef, nd)

    dc = Matrix{Float64}(undef, nd, size(rc, 2))

    for (i1, (be, af)) in enumerate(ba_)

        di_[i1] = join(
            (sb == sa ? sb : "($sa - $sb)" for (sb, sa) in zip(eachsplit(be), eachsplit(af))),
            ' ',
        )

        dc[i1, :] .=
            rc[Nucleus.Collection.find(af, ro_), :] .- rc[Nucleus.Collection.find(be, ro_), :]

    end

    di_, dc

end

function read(ou, ip, sd, fu_, rn_, sa_)

    ir_, pi_, ia = read_demographic(ip)

    for (pr, ba_) in fu_

        ft_, pf_, fp = read_function(ip, pr)

        # TODO
        #foreach(Nucleus.Number.replace_nan!, eachrow(fp))

        if !isempty(ba_)

            di_, dp = _get_difference(ft_, fp, ba_)

            append!(ft_, di_)

            fp = vcat(fp, dp)

            i2_ = sortperm(mean.(eachcol(dp)))

        else

            i2_ = eachindex(pf_)

        end

        Nucleus.Plot.plot_heat_map(
            joinpath(ou, "$pr.html"),
            fp[:, i2_];
            y = ft_,
            x = pf_[i2_],
            nr = "Time",
            nc = "Participant",
            co = Nucleus.Color.COPA,
            layout = Dict("title" => Dict("text" => "$sd $pr")),
        )

        append!(ir_, (ft -> "$pr $ft").(ft_))

        ia = vcat(ia, Nucleus.FeatureXSample.assimilate(pi_, pf_, fp))

    end

    ir_, ia = Nucleus.FeatureXSample.remove_constant(ir_, ia, 1)

    r1_, s1_, n1 = read_rna(ip, rn_[1])

    for rn in rn_[2:end]

        r2_, s2_, n2 = read_rna(ip, rn)

        @assert r1_ == r2_

        append!(s1_, s2_)

        n1 = hcat(n1, n2)

    end

    if sa_ isa AbstractString

        na_sa = read_sample_map(ip, sa_)

        sa_ = (s1 -> na_sa[s1]).(s1_)

    else

        @assert lastindex(s1_) == lastindex(sa_) lastindex(s1_)

    end

    sa_,
    ir_,
    Nucleus.FeatureXSample.assimilate(Nucleus.String.split_get.(sa_, ' ', 1), pi_, ia),
    r1_,
    n1

end

function _finish_previous(u2_)

    unique!(u2_)

    nu = lastindex(u2_)

    mu = 1 < nu

    if mu

        @info "👤 $nu."

    end

    empty!(u2_)

    println()

    mu

end

function xxx(r1_, c1_, m1, r2_, m2, s2_, t2_)

    i1_ = sortperm(c1_)

    c1_ = c1_[i1_]

    m1 = m1[:, i1_]

    ri_ = intersect(r1_, r2_)

    @info "$(lastindex(ri_)) / ($(lastindex(r1_)) & $(lastindex(r2_)))."

    i1_ = indexin(ri_, r1_)

    i2_ = indexin(ri_, r2_)

    p1 = nothing

    u2_ = String[]

    ns = nt = 0

    np = maximum(lastindex, s2_) + 16

    for (c1, n1_) in zip(c1_, eachcol(m1))

        s1 = Nucleus.String.split_get(c1, '.', 1)[7:end]

        t1 = Nucleus.String.split_get(c1, ' ', 2)

        if p1 != s1

            ns += _finish_previous(u2_)

            p1 = s1

        end

        n1_ = n1_[i1_]

        ib = rb = 0

        for (i2, n2_) in enumerate(eachcol(m2))

            re = Nucleus.Information.cor(n1_, n2_[i2_])

            if rb < re

                ib = i2

                rb = re

            end

        end

        s2 = s2_[ib]

        t2 = t2_[ib]

        push!(u2_, s2)

        st = "$(rpad("$s1 @ $t1", 16))$(rpad("$s2 @ $t2", np))$(rpad(Nucleus.Number.format4(rb), 8))"

        if t1 != t2

            nt += 1

            st *= " 👎"

        end

        @info st

    end

    ns += _finish_previous(u2_)

    @info "👤 $ns / $(lastindex(unique(Nucleus.String.split_get.(c1_, ' ', 1))))."

    @info "👎 $nt / $(lastindex(c1_))."

end

end
