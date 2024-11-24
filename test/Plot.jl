using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

# 2.083 ns (0 allocations: 0 bytes)
# 2.125 ns (0 allocations: 0 bytes)
# 2.084 ns (0 allocations: 0 bytes)
for (mi, ma, ex, re) in
    ((0, 1, 0.1, (-0.1, 1.1)), (-1, 1, 0.1, (-1.2, 1.2)), (900, 1000, 0.1, (890.0, 1010.0)))

    @test Omics.Plot.rang(mi, ma, ex) === re

    #@btime Omics.Plot.rang($mi, $ma, $ex)

end

# ---- #

Omics.Plot.plot(
    "",
    (Dict("y" => (1, 2), "x" => (3, 4)),),
    Dict(
        "title" => "Title",
        "yaxis" => Dict("title" => Dict("text" => "Y-Axis Title")),
        "xaxis" => Dict("title" => Dict("text" => "X-Axis Title")),
    ),
)

# ---- #

const MA = [
    0.999 3 5
    2 4 6.001
]

const RO_ = ("Aa", "Bb")

const CO_ = ("Cc", "Dd", "Ee")

# ---- #

Omics.Plot.plot_heat_map("", MA; ro_ = RO_, co_ = CO_)

# ---- #

Omics.Plot.plot_bubble_map("", MA * 40, MA; ro_ = RO_, co_ = CO_)

Omics.Plot.plot_bubble_map("", MA * 40, reverse(MA); ro_ = RO_, co_ = CO_)

# ---- #

const T3_ = 0:30:360

const T4 = 0:45:360

const T6 = 0:60:360

Omics.Plot.plot_radar(
    "",
    (T3_, T4, T6),
    (eachindex(T3_), eachindex(T4), eachindex(T6));
    na_ = (30, 45, 60),
    la = Dict("title" => Dict("text" => "Title Text")),
)

# ---- #

Omics.Plot.animate(
    joinpath(tempdir(), "animate.gif"),
    (pkgdir(Omics, "data", "Plot", "$id.png") for id in 1:2),
)

# ---- #

function _annotate(ti, st, he)

    wi = 2.4

    Dict(
        "y" => 0,
        "x" => ti,
        "text" => st,
        "textangle" => -90,
        "font" => Dict("size" => 32, "color" => "#ffffff"),
        "arrowside" => "none",
        "arrowwidth" => wi,
        "arrowcolor" => he,
        "borderwidth" => wi,
        "bordercolor" => he,
        "borderpad" => 4 * wi,
    )

end

function plot_timeline(ht, ti_, he, ev_)

    ba = "#27221f"

    Omics.Plot.plot(
        ht,
        (),
        Dict(
            "paper_bgcolor" => ba,
            "plot_bgcolor" => ba,
            "yaxis" => Dict("range" => (0, 1), "tickvals" => ()),
            "xaxis" => Dict(
                "range" => ti_,
                "linewidth" => 4,
                "linecolor" => he,
                "tickvals" => vcat(ti_, [ev_[1] for ev_ in ev_]),
                "tickcolor" => he,
                "tickfont" => Dict("size" => 24, "color" => "#ffffff"),
                "tickangle" => -90,
            ),
            "annotations" => [_annotate(ti, st, he) for (ti, st, he) in ev_],
        ),
        Dict("editable" => true),
    )

end

const HB = "#e06351"

const HI = "#6c9956"

plot_timeline(
    joinpath(homedir(), "Downloads", "timeline.html"),
    [1999, 2025],
    "#ffffff",
    (
        (1996, "Spin Column Nucleic Acid Purification", HB),
        (1999, "RNAlater", HB),
        (2000, "Structural Causal Model", HI),
        (2003, "The PAXgene Blood RNA Tube", HB),
        (2005, "Globin Depletion", HB),
        (2006, "Sequencing by Synthesis (SBS)", HB),
        (2009, "Probabilistic Graphical Models", HI),
        (2010, "Nucleic Acid Extraction Filter Plates", HB),
        (2011, "Whole-Blood RNA Sequencing", HB),
        (2015, "Illumina NextSeq", HB),
        (2018, "Julia Language 1.0", HI),
        (2019, "MacBook with 64 GB of RAM", HI),
        (2022, "Self-Collection Blood Sampling", HB),
        (2023, "XLEAP SBS", HB),
        (2023, "Illumina NovaSeq X", HB),
    ),
)
