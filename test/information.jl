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
OnePiece.information.get_entropy(zeros(10))

OnePiece.information.get_entropy(ones(10))

# ----------------------------------------------------------------------------------------------- #
for (te1, te2) in [
    (collect(1:3), collect(10:10:30)),
    (zeros(3), zeros(3)),
    (ones(3), [0.001, 0.001, 0.001]),
    ([0.001, 0.001, 0.001], ones(3)),
    ([0.001, 0.001, 0.001], [10, 10, 10]),
]

    println(OnePiece.information.get_signal_to_noise_ratio(te1, te2))

end

# ----------------------------------------------------------------------------------------------- #
function call_all(te1, te2, te)

    vcat(
        [
            fu(te1, te2) for fu in [
                OnePiece.information.get_kolmogorov_smirnov_statistic,
                OnePiece.information.get_kullback_leibler_divergence,
                OnePiece.information.get_thermodynamic_breadth,
                OnePiece.information.get_thermodynamic_depth,
            ]
        ],
        [
            fu(te1, te2, te) for fu in [
                OnePiece.information.get_jensen_shannon_divergence,
                OnePiece.information.get_kwat_pablo_divergence,
            ]
        ],
    )

end

# ----------------------------------------------------------------------------------------------- #
name_ = [
    "kolmogorov_smirnov_statistic",
    "kullback_leibler_divergence",
    "thermodynamic_breadth",
    "thermodynamic_depth",
    "jensen_shannon_divergence",
    "kwat_pablo_divergence",
]

for (te1, te2) in [([1, 1, 1], [1, 1, 1]), ([1, 2, 3], [10, 20, 30])]

    te = 0.2 * te1 + 0.8 * te2

    display(OnePiece.figure.plot_x_y([te1, te2]))

    display(OnePiece.figure.plot_x_y(call_all(te1, te2, te); name_ = name_))

end

# ----------------------------------------------------------------------------------------------- #
n_po = 100

te1 = OnePiece.tensor.shift_minimum(randn(n_po), "0<")

ve1s = te1 .+ 1

te2 = OnePiece.tensor.shift_minimum(randn(n_po), "0<")

# ----------------------------------------------------------------------------------------------- #
using KernelDensity

# ----------------------------------------------------------------------------------------------- #
for (te1, te2) in [(te1, te1), (te1, ve1s), (te1, te2)]

    un1 = kde(te1)

    un2 = kde(te2)

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

# ----------------------------------------------------------------------------------------------- #
te1 = collect(0:10)

te2 = collect(0:10:100)

bi = kde((te1, te2), npoints = (8, 8))

y = collect(bi.y)

x = collect(bi.x)

z = bi.density

display(OnePiece.figure.plot_heat_map(z, y, x))

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
