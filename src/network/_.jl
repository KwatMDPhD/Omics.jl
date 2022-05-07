module network

using DefaultApplication
using Graphs
using NetworkLayout

using ..OnePiece

function make_arrow_wing(θ, dex, dey, le, an = 19.0 / 180.0 * π)

    x1 = dex - le * cos(θ + an)

    y1 = dey - le * sin(θ + an)

    x2 = dex - le * cos(θ - an)

    y2 = dey - le * sin(θ - an)

    (x1, y1), (x2, y2)

end

function plot(ve_, ed_; gr_ = [], grn_ = [], grc_ = [], la = Dict(), ou = "")

    ne = DiGraph(length(ve_))

    for ed in ed_

        add_edge!(ne, ed)

    end

    println(ne)

    println("has_self_loops = $(has_self_loops(ne))")

    vey_ = []

    vex_ = []

    for (vex, vey) in spring(ne, C = 4, iterations = 1000)

        push!(vey_, vey)

        push!(vex_, vex)

    end

    trvb = Dict(
        "mode" => "markers+text",
        "opacity" => 0.8,
        "marker" => Dict{String, Any}("size" => 16),
        "textposition" => "top center",
        "hoverinfo" => "text",
    )

    trv_ = []

    if isempty(gr_)

        trv =
            OnePiece.dict.merge(trvb, Dict("name" => "", "y" => vey_, "x" => vex_, "text" => ve_))

        push!(trv_, trv)

    else

        for gr in sort(unique(gr_))

            is_ = gr_ .== gr

            trv = OnePiece.dict.merge(
                trvb,
                Dict("name" => grn_[gr], "y" => vey_[is_], "x" => vex_[is_], "text" => ve_[is_]),
            )

            if !isempty(grc_)

                trv["marker"]["color"] = grc_[gr]

            end

            push!(trv_, trv)

        end

    end

    edy_ = []

    edx_ = []

    for (id1, id2) in ed_

        #
        Δx = vex_[id2] - vex_[id1]

        Δy = vey_[id2] - vey_[id1]

        si = 0.16

        θ = atan(Δy, Δx)

        sox = vex_[id1] + si * cos(θ)

        soy = vey_[id1] + si * sin(θ)

        dex = vex_[id2] + si * cos(θ + π)

        dey = vey_[id2] + si * sin(θ + π)

        append!(edy_, (soy, dey, nothing))

        append!(edx_, (sox, dex, nothing))

        (arx1, ary1), (arx2, ary2) = make_arrow_wing(θ, dex, dey, 0.1)

        append!(edy_, (ary1, dey, ary2, nothing))

        append!(edx_, (arx1, dex, arx2, nothing))
        #

    end

    tre_ = [
        Dict(
            "name" => "",
            "mode" => "lines",
            "y" => edy_,
            "x" => edx_,
            "opacity" => 0.4,
            "hoverinfo" => "none",
            "marker" => Dict("color" => "#181b26"),
        ),
    ]

    si = 1000

    axis = Dict("visible" => false)

    la = OnePiece.dict.merge(
        Dict(
            "height" => si,
            "width" => si * MathConstants.golden,
            "yaxis" => axis,
            "xaxis" => axis,
            "legend" => Dict("orientation" => "h"),
        ),
        la,
    )

    DefaultApplication.open(OnePiece.figure.plot(vcat(trv_, tre_), la, ou = ou))

end

end
