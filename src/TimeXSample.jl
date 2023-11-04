module TimeXSample

using ..Nucleus

function _expand(ti_, ti_x_sa_x_nu)

    if !all(>(0), diff(ti_))

        error("Times are not increasing. $ti_.")

    end

    st_x_sa_x_nu = Matrix{Float64}(undef, 5, size(ti_x_sa_x_nu, 2))

    for (id, nu_) in enumerate(eachcol(ti_x_sa_x_nu))

        st_x_sa_x_nu[1, id] = maximum(nu_)

        st_x_sa_x_nu[2, id] = sum(nu_)

        st_x_sa_x_nu[3, id] = nu_[end] - nu_[1]

        de = ic = 0

        for di in diff(nu_)

            if di < 0

                de -= di

            elseif 0 < di

                ic += di

            end

        end

        st_x_sa_x_nu[4, id] = de

        st_x_sa_x_nu[5, id] = ic

    end

    vcat(ti_, ["Maximum", "Sum", "Change", "Decrease", "Increase"]),
    vcat(ti_x_sa_x_nu, st_x_sa_x_nu)

end

function write(di, ti_, sa_, ti_x_sa_x_nu; nat = "Time", nas = "Sample", nan = "Number")

    Nucleus.Error.error_missing(di)

    Nucleus.Plot.plot_scatter(
        joinpath(di, "change_$(Nucleus.Path.clean(nat)).html"),
        eachcol(ti_x_sa_x_nu),
        fill(ti_, lastindex(sa_));
        name_ = sa_,
        layout = Dict(
            "yaxis" => Dict("title" => Dict("text" => nan)),
            "xaxis" => Dict("title" => Dict("text" => nat)),
        ),
    )

    pr = joinpath(
        di,
        "$(Nucleus.Path.clean(nat))_x_$(Nucleus.Path.clean(nas))_x_$(Nucleus.Path.clean(nan))",
    )

    Nucleus.Plot.plot_heat_map(
        "$pr.html",
        ti_x_sa_x_nu;
        y = string.(nat, ' ', ti_),
        x = sa_,
        nar = nat,
        nac = nas,
        layout = Dict("height" => 160 * lastindex(ti_), "title" => Dict("text" => nan)),
    )

    ex_, ex_x_sa_x_fl = _expand(ti_, ti_x_sa_x_nu)

    Nucleus.DataFrame.write("$pr.tsv", nat, ex_, sa_, ex_x_sa_x_fl)

end

end
