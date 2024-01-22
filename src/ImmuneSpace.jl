module ImmuneSpace

# TODO: Implement `Nucleus.FeatureXSample.join_row`.
using DataFrames: outerjoin

using ..Nucleus

function _read_demographic(ip)

    _np, pa_, de_, ma = Nucleus.DataFrame.separate(joinpath(ip, "demographics.tsv"))

    pe = permutedims(ma)

    @info "🧖‍♀️ Demographic" de_ pa_ pe

    de_, pa_, pe

end

function _read_feature(ip, tf::AbstractString)

    _nf, fe_, sa_, ma = Nucleus.DataFrame.separate(joinpath(ip, tf))

    st_ = string.(fe_)

    @info "🧬 Feature" st_ sa_ ma

    st_, sa_, ma

end

function _read_feature(ip, tf)

    _nf, fe_, sa_, ma = Nucleus.DataFrame.separate(
        outerjoin((Nucleus.DataFrame.read(joinpath(ip, tf)) for tf in tf)...; on = "feature_id"),
    )

    string.(fe_), sa_, replace(ma, missing => NaN)

end

function _read_feature_map(ip)

    fe_f2 = Dict{String, String}()

    ts = joinpath(ip, "FeatureAnnotation.tsv")

    if isfile(ts)

        for (fe, f2) in
            eachrow(Matrix(Nucleus.DataFrame.read(ts; select = ["Feature Id", "Gene Symbol"])))

            fe_f2[string(fe)] = f2

        end

    end

    fe_f2

end

function _get_unit(an_)

    un_ = unique(an_)

    @assert isone(lastindex(un_))

    un = un_[1]

    if un == "Days"

        "Day"

    elseif un == "Antibody titer"

        "Antibody Titer"

    end

end

function _read_sample_map(ip)

    pa_, ti_, un_ = eachcol(
        Matrix(
            Nucleus.DataFrame.read(
                joinpath(ip, "gene_expression_files.tsv");
                select = ["Participant ID", "Study Time Collected", "Study Time Collected Unit"],
            ),
        ),
    )

    pa_, convert(Vector{Int}, ti_), _get_unit(un_)

end

function _read_neut_ab_titer(ip)

    pa_, ti_, ut_, vi_, nu_, un_ = eachcol(
        Matrix(
            Nucleus.DataFrame.read(
                joinpath(ip, "neut_ab_titer.tsv");
                select = [
                    "Participant ID"
                    "Study Time Collected"
                    "Study Time Collected Unit"
                    "Virus"
                    "Value Preferred"
                    "Unit Preferred"
                ],
            ),
        ),
    )

    vt_, pa_, ma = Nucleus.Target.tabulate(
        (Nucleus.String.clean.(vi_), convert(Vector{Int}, ti_)),
        (pa_,),
        nu_,
    )

    @info "🏹 Antibody" vt_ pa_ ma

    vt_, pa_, ma, _get_unit(ut_), _get_unit(un_)

end

function _initialize_block()

    String[], String[], Vector{String}[], Vector{String}[], Matrix[]

end

function _push_block!(ts_, nr_, ro___, co___, ma_, ts, nr, ro_, co_, ma)

    push!(ts_, ts)

    push!(nr_, nr)

    push!(ro___, ro_)

    push!(co___, co_)

    push!(ma_, ma)

    nothing

end

function _intersect_block!(co___, ma_)

    it_ = intersect(co___...)

    Nucleus.FeatureXSample.log_intersection(co___, it_)

    for (id, (co_, ma)) in enumerate(zip(co___, ma_))

        ma_[id] = ma[:, indexin(it_, co_)]

    end

    it_

end

function _write_block(ts_, nr_, ro___, co_, ma_)

    for (ts, nr, ro_, ma) in zip(ts_, nr_, ro___, ma_)

        Nucleus.DataFrame.write(ts, nr, ro_, co_, ma)

        @info "📝 $ts." nr ro_ co_ ma

    end

end

function get(ou, ip, tf; ts = nothing, lo = false, ne = true)

    Nucleus.Error.error_missing(ou)

    ts_, nr_, ro___, co___, ma_ = _initialize_block()

    de_, pa_, an = _read_demographic(ip)

    _push_block!(
        ts_,
        nr_,
        ro___,
        co___,
        ma_,
        joinpath(ou, "demographic_x_participant_x_any.tsv"),
        "Information",
        de_,
        pa_,
        an,
    )

    fe_, sa_, mf = _read_feature(ip, tf)

    fe_, mf = Nucleus.FeatureXSample.transform(
        fe_,
        sa_,
        mf;
        ro_r2 = _read_feature_map(ip),
        lo,
        nr = "Gene",
        nc = "Participant",
        nn = "Transcription",
    )

    pa_, ti_, un = _read_sample_map(ip)

    @assert lastindex(sa_) == lastindex(pa_)

    ke_ar = (y = fe_, nr = "Gene", layout = Dict("title" => Dict("text" => "Transcription")))

    for (ti, id_) in sort(Nucleus.Collection.map_index(ti_))

        if !isnothing(ts) && ti != ts

            continue

        end

        pi_ = pa_[id_]

        mi = mf[:, id_]

        pr = joinpath(ou, "gene_x_participant$(ti)_x_transcription")

        _push_block!(ts_, nr_, ro___, co___, ma_, "$pr.tsv", "Gene", fe_, pi_, mi)

        Nucleus.Plot.plot_heat_map("$pr.html", mi; x = pi_, nc = "Participant $un $ti", ke_ar...)

    end

    if ne

        vt_, pa_, mn, ut, un = _read_neut_ab_titer(ip)

        nv = lastindex(vt_)

        vi_ = Vector{String}(undef, nv)

        ti_ = Vector{Int}(undef, nv)

        for (id, (vi, ti)) in enumerate(vt_)

            vi_[id] = vi

            ti_[id] = ti

        end

        ke_ar = (x = pa_, nr = ut, nc = "Participant")

        for (vi, id_) in Nucleus.Collection.map_index(vi_)

            td_ = string.("@ ", ti_[id_])

            md = mn[id_, :]

            pr = joinpath(
                ou,
                "time_$(Nucleus.Path.clean(vi))_x_participant_x_$(Nucleus.Path.clean(un))",
            )

            _push_block!(ts_, nr_, ro___, co___, ma_, "$pr.tsv", "Target", td_, pa_, md)

            Nucleus.Plot.plot_heat_map(
                "$pr.html",
                md;
                y = td_,
                layout = Dict("title" => Dict("text" => vi)),
                ke_ar...,
            )

        end

    end

    _write_block(ts_, nr_, ro___, _intersect_block!(co___, ma_), ma_)

end

end
