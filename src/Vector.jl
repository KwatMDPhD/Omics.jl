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

function _make_layout(title_text, xaxis_title_text)

    Dict(
        "title" => Dict("text" => title_text),
        "xaxis" => Dict("title" => Dict("text" => xaxis_title_text)),
    )

end

function select(st_, re_, mi, ma, xaxis_title_text)

    BioLab.Array.error_size_difference((st_, re_))

    n = length(st_)

    BioLab.Plot.plot_histogram(
        "",
        (re_,),
        (st_,);
        layout = _make_layout("All $n", xaxis_title_text),
    )

    ke_ = map(re -> mi <= re <= ma, re_)

    n_ke = sum(ke_)

    pe = BioLab.String.format(n_ke / n * 100)

    BioLab.Plot.plot_histogram(
        "",
        (re_[ke_],),
        (st_[ke_],);
        layout = _make_layout("Selected $n_ke ($pe%) between $mi and $ma", xaxis_title_text),
    )

    ke_

end

end
