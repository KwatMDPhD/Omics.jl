# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "information.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")


# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
OnePiece.information.get_entropy

ve1 = collect(1:3)

ve2 = collect(10:10:30)

OnePiece.information.get_signal_to_noise_ratio(ve1, ve2)

function call_all(ve1, ve2, ve)

    vcat(
        [
            fu(ve1, ve2) for fu in [
                OnePiece.information.get_kolmogorov_smirnov_statistic,
                OnePiece.information.get_kullback_leibler_divergence,
                OnePiece.information.get_thermodynamic_breadth,
                OnePiece.information.get_thermodynamic_depth,
            ]
        ],
        [
            fu(ve1, ve2, ve) for fu in [
                OnePiece.information.get_jensen_shannon_divergence,
                OnePiece.information.get_kwat_pablo_divergence,
            ]
        ],
    )

end

name_ = [
    "kolmogorov_smirnov_statistic",
    "kullback_leibler_divergence",
    "thermodynamic_breadth",
    "thermodynamic_depth",
    "jensen_shannon_divergence",
    "kwat_pablo_divergence",
]

for (ve1, ve2) in [([1, 1, 1], [1, 1, 1]), ([1, 2, 3], [10, 20, 30])]

    ve = 0.2 * ve1 + 0.8 * ve2

    OnePiece.figure.plot_x_y([ve1, ve2])

    OnePiece.figure.plot_x_y(call_all(ve1, ve2, ve); name_ = name_)

end

n_po = 100

ve1 = OnePiece.tensor.shift_minimum(randn(n_po), "0<")

ve1s = ve1 .+ 1

ve2 = OnePiece.tensor.shift_minimum(randn(n_po), "0<")

;

using KernelDensity

for (ve1, ve2) in [(ve1, ve1), (ve1, ve1s), (ve1, ve2)]

    un1 = kde(ve1)

    un2 = kde(ve2)

    de1 = un1.density

    de2 = un2.density

    de3 = 0.2 * de1 + 0.8 * de2

    display(
        OnePiece.figure.plot_x_y(
            [de1, de2],
            [collect(un1.x), collect(un2.x)];
            la = Dict("yaxis" => Dict("title" => "Density"), "xaxis" => Dict("title" => "Grid")),
        ),
    )

    display(OnePiece.figure.plot_x_y(call_all(de1, de2, de3); name_ = name_))

end

ve1 = collect(0:10)

ve2 = collect(0:10:100)

;

bi = kde((ve1, ve2); npoints = (8, 8))

y = collect(bi.y)

x = collect(bi.x)

z = bi.density

display(OnePiece.figure.plot_heat_map(z))

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
