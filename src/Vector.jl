module Vector

using ..BioLab

function get_extreme(n::Int, n_ex)

    if n / 2 < n_ex

        collect(1:n)

    else

        vcat(collect(1:n_ex), collect((n - n_ex + 1):n))

    end

end

function get_extreme(an_::AbstractVector, n_ex)

    sortperm(an_)[get_extreme(length(an_), n_ex)]

end

function get_extreme(fl_::AbstractVector{Float64}, n_ex)

    sortperm(fl_)[get_extreme(length(fl_) - sum(isnan, fl_), n_ex)]

end

function sort_like(an___; rev = false)

    id_ = sortperm(an___[1]; rev)

    (an_[id_] for an_ in an___)

end

# TODO: Test.
function skip_nan_sort_like(fl_, an_; rev = false)

    go_ = findall(!isnan, fl_)

    sort_like((fl_[go_], an_[go_]); rev)

end

function _make_layout(title_text, xaxis_title_text)

    Dict(
        "title" => Dict("text" => title_text),
        "xaxis" => Dict("title" => Dict("text" => xaxis_title_text)),
    )

end

function select(
    ht,
    me_,
    mi,
    ma;
    nat = "Thing",
    th_ = map(id -> "Thing $id", eachindex(me_)),
    nam = "Metric",
)

    BioLab.Array.error_size_difference((th_, me_))

    n = length(th_)

    BioLab.Plot.plot_histogram("", (me_,), (th_,); layout = _make_layout("All $n $nat", nam))

    ke_ = map(me -> mi <= me <= ma, me_)

    n_ke = sum(ke_)

    pe = BioLab.String.format(n_ke / n * 100)

    BioLab.Plot.plot_histogram(
        ht,
        (me_[ke_],),
        (th_[ke_],);
        layout = _make_layout("Selected $n_ke ($pe%) $nat between $mi and $ma", nam),
    )

    ke_

end

end
