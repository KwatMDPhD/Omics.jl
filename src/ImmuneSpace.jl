module ImmuneSpace

# TODO: Implement `Nucleus.FeatureXSample.join_row`.
using DataFrames: outerjoin

using ..Nucleus

function _read_demographic(ip)

    _nap, pa_, de_, pa_x_de_x_an = Nucleus.DataFrame.separate(joinpath(ip, "demographics.tsv"))

    de_x_pa_x_an = permutedims(pa_x_de_x_an)

    @info "🧖‍♀️ Demographic" de_ pa_ de_x_pa_x_an

    de_, pa_, de_x_pa_x_an

end

function _read_feature(ip, tsf::AbstractString)

    _naf, fe_, sa_, fe_x_sa_x_nu = Nucleus.DataFrame.separate(joinpath(ip, tsf))

    fe_ = string.(fe_)

    @info "🧬 Feature" fe_ sa_ fe_x_sa_x_nu

    fe_, sa_, fe_x_sa_x_nu

end

function _read_feature(ip, tsf)

    _naf, fe_, sa_, fe_x_sa_x_nu = Nucleus.DataFrame.separate(
        outerjoin(
            (Nucleus.DataFrame.read(joinpath(ip, tsf)) for tsf in tsf)...;
            on = "feature_id",
        ),
    )

    string.(fe_), sa_, replace(fe_x_sa_x_nu, missing => NaN)

end

function _read_feature_map(ip)

    fe_fe2 = Dict{String, String}()

    ts = joinpath(ip, "FeatureAnnotation.tsv")

    if isfile(ts)

        for (fe, fe2) in
            eachrow(Matrix(Nucleus.DataFrame.read(ts; select = ["Feature Id", "Gene Symbol"])))

            fe_fe2[string(fe)] = fe2

        end

    end

    fe_fe2

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

    pa_, ti_, unt_, vi_, nu_, unn_ = eachcol(
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

    vt_, pa_, vt_x_pa_x_nu = Nucleus.Target.tabulate(
        (Nucleus.String.clean.(vi_), convert(Vector{Int}, ti_)),
        (pa_,),
        nu_,
    )

    @info "🏹 Antibody" vt_ pa_ vt_x_pa_x_nu

    vt_, pa_, vt_x_pa_x_nu, _get_unit(unt_), _get_unit(unn_)

end

function _initialize_block()

    String[], String[], Vector{String}[], Vector{String}[], Matrix[]

end

function _push_block!(ts_, nar_, ro___, co___, ma_, ts, nar, ro_, co_, ma)

    push!(ts_, ts)

    push!(nar_, nar)

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

function _write_block(ts_, nar_, ro___, co_, ma_)

    for (ts, nar, ro_, ma) in zip(ts_, nar_, ro___, ma_)

        Nucleus.DataFrame.write(ts, nar, ro_, co_, ma)

        @info "📝 $ts." nar ro_ co_ ma

    end

end

function get(ou, ip, tsf; ts = nothing, lo = false, ne = true)

    Nucleus.Error.error_missing(ou)

    ts_, nar_, ro___, co___, ma_ = _initialize_block()

    de_, pa_, de_x_pa_x_an = _read_demographic(ip)

    _push_block!(
        ts_,
        nar_,
        ro___,
        co___,
        ma_,
        joinpath(ou, "demographic_x_participant_x_any.tsv"),
        "Information",
        de_,
        pa_,
        de_x_pa_x_an,
    )

    fe_, sa_, fe_x_sa_x_nu = _read_feature(ip, tsf)

    fe_, fe_x_sa_x_nu = Nucleus.FeatureXSample.transform(
        fe_,
        sa_,
        fe_x_sa_x_nu;
        ro_ro2 = _read_feature_map(ip),
        lo,
        nar = "Gene",
        nac = "Participant",
        nan = "Transcription",
    )

    pa_, ti_, un = _read_sample_map(ip)
    @assert lastindex(sa_) == lastindex(pa_)

    ke_ar = (y = fe_, nar = "Gene", layout = Dict("title" => Dict("text" => "Transcription")))

    for (ti, id_) in sort(Nucleus.Collection.map_index(ti_))

        if !isnothing(ts) && ti != ts

            continue

        end

        pai_ = pa_[id_]

        fe_x_sai_x_nu = fe_x_sa_x_nu[:, id_]

        pr = joinpath(ou, "gene_x_participant$(ti)_x_transcription")

        _push_block!(ts_, nar_, ro___, co___, ma_, "$pr.tsv", "Gene", fe_, pai_, fe_x_sai_x_nu)

        Nucleus.Plot.plot_heat_map(
            "$pr.html",
            fe_x_sai_x_nu;
            x = pai_,
            nac = "Participant $un $ti",
            ke_ar...,
        )

    end

    if ne

        vt_, pa_, vt_x_pa_x_nu, unt, unn = _read_neut_ab_titer(ip)

        n = lastindex(vt_)

        vi_ = Vector{String}(undef, n)

        ti_ = Vector{Int}(undef, n)

        for (id, (vi, ti)) in enumerate(vt_)

            vi_[id] = vi

            ti_[id] = ti

        end

        ke_ar = (x = pa_, nar = unt, nac = "Participant")

        for (vi, id_) in Nucleus.Collection.map_index(vi_)

            tii_ = string.("@ ", ti_[id_])

            vti_x_pa_x_nu = vt_x_pa_x_nu[id_, :]

            pr = joinpath(
                ou,
                "time_$(Nucleus.Path.clean(vi))_x_participant_x_$(Nucleus.Path.clean(unn))",
            )

            _push_block!(
                ts_,
                nar_,
                ro___,
                co___,
                ma_,
                "$pr.tsv",
                "Target",
                tii_,
                pa_,
                vti_x_pa_x_nu,
            )

            Nucleus.Plot.plot_heat_map(
                "$pr.html",
                vti_x_pa_x_nu;
                y = tii_,
                layout = Dict("title" => Dict("text" => vi)),
                ke_ar...,
            )

        end

    end

    co_ = _intersect_block!(co___, ma_)

    _write_block(ts_, nar_, ro___, co_, ma_)

end

end
