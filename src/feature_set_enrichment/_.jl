using ..informatics.tensor: cumulate_sum_reverse
using StatsBase: sample
using ..io.gmt: read as io_gmt_read
using ..io.table: read as io_table_read
using ..extension.constant: CARD
using PlotlyJS: Layout, SyncPlot, attr, scatter
using Printf: @sprintf

using ..figure: plot
using ..informatics.geometry: get_center
using DataFrames: DataFrame

using ..extension.vector: is_in, sort_like

using ..extension.vector: is_in

using ..informatics.tensor: get_area
using ..informatics.information: get_relative_information_difference
using OrderedCollections: OrderedDict

using ..extension.vector: is_in, sort_like

using ..figure: plot_x_y
using ..informatics.information:
    get_kolmogorov_smirnov_statistic,
    get_relative_information_sum,
    get_relative_information_sum,
    get_relative_information_difference,
    get_relative_information_difference,
    get_symmetric_information_sum,
    get_symmetric_information_difference
using ..informatics.tensor: get_area, get_extreme
