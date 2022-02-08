using DataFrames: DataFrame
using OrderedCollections: OrderedDict
using PlotlyJS: Layout, attr, scatter
using Printf: @sprintf
using StatsBase: sample

using ..extension.constant: CARD
using ..extension.vector: is_in, sort_like
using ..figure: plot, plot_x_y
using ..informatics.geometry: get_center
using ..informatics.information:
    get_kolmogorov_smirnov_statistic,
    get_jensen_shannon_divergence,
    get_kwat_pablo_divergence,
    get_thermodynamic_breadth,
    get_thermodynamic_depth
using ..informatics.tensor: cumulate_sum_reverse, get_area, get_extreme
using ..io.gmt: read as gmt_read
using ..io.table: read as table_read
