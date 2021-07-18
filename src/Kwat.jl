module Kwat

include("DataIO/read_data.jl")

include("FeatureSetEnrichment/_plot.jl")
include("FeatureSetEnrichment/score_set.jl")
include("FeatureSetEnrichment/make_benchmark.jl")
include("FeatureSetEnrichment/score_set.jl")
include("FeatureSetEnrichment/score_set_new.jl")
include("FeatureSetEnrichment/sum_h_absolute_and_n_m.jl")

include("GCTGMT/read_gct.jl")
include("GCTGMT/read_gmt.jl")

include("Information/compute_ic.jl")
include("Information/compute_ided.jl")
include("Information/compute_ides.jl")
include("Information/compute_idrd.jl")
include("Information/compute_idrs.jl")
include("Information/compute_kld.jl")
include("Information/compute_mi.jl")
include("Information/compute_s.jl")

include("Normalization/normalize.jl")

include("Plot/plot_bar.jl")
include("Plot/plot_bubble_map.jl")
include("Plot/plot_heat_map.jl")
include("Plot/plot_histogram.jl")
include("Plot/plot_pie.jl")
include("Plot/plot_point.jl")
include("Plot/plot_point_3d.jl")
include("Plot/plot_x_y.jl")
include("Plot/use_style!.jl")

include("Support/check_is.jl")
include("Support/convert_vector_of_vector_to_matrix.jl")
include("Support/cumulate_sum_reverse.jl")
include("Support/get_area.jl")
include("Support/get_center.jl")
include("Support/get_extreme.jl")
include("Support/list_card.jl")
include("Support/merge_recursively.jl")
include("Support/read_directory.jl")
include("Support/read_json.jl")
include("Support/replace_multiple.jl")
include("Support/shift_minimum.jl")
include("Support/sort_like.jl")
include("Support/sum_where.jl")
include("Support/title.jl")

end
