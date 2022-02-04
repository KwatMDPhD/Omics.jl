module OnePiece

module information

	include("information/get_entropy.jl")

	include("information/get_information_coefficient.jl")

	include("information/get_kolmogorov_smirnov_statistic.jl")

	include("information/get_kullback_leibler_divergence.jl")

	include("information/get_mutual_information.jl")

	include("information/get_relative_information_difference.jl")

	include("information/get_relative_information_sum.jl")

	include("information/get_signal_to_noise_ratio.jl")

	include("information/get_symmetric_information_difference.jl")

	include("information/get_symmetric_information_sum.jl")

end

module tensor_function

	include("tensor_function/apply.jl")

end

module feature_by_sample

	include("feature_by_sample/compare_with_target.jl")

end

module more_constant

	include("more_constant/CARD.jl")

end

module more_dict

	include("more_dict/convert_to_keyword_argument.jl")

	include("more_dict/merge.jl")

	include("more_dict/read.jl")

	include("more_dict/sort_recursively!.jl")

	include("more_dict/summarize.jl")

	include("more_dict/write.jl")

end

module more_geometry

	include("more_geometry/get_center.jl")

end

module more_path

	include("more_path/clean.jl")

	include("more_path/error_extension.jl")

	include("more_path/error_missing_path.jl")

	include("more_path/get_download_directory.jl")

	include("more_path/get_file_name_without_extension.jl")

	include("more_path/make_absolute.jl")

	include("more_path/move.jl")

	include("more_path/sed_recursively.jl")

	include("more_path/select.jl")

	include("more_path/shorten.jl")

end

module more_statistics

	include("more_statistics/get_confidence_interval.jl")

	include("more_statistics/get_z_score.jl")

end

module more_string

	include("more_string/get_longest_common_prefix.jl")

	include("more_string/remove_longest_common_prefix.jl")

	include("more_string/replace.jl")

	include("more_string/title.jl")

	include("more_string/transplant.jl")

end

module more_template

	include("more_template/error_missing.jl")

	include("more_template/get_replacement.jl")

	include("more_template/get_transplant.jl")

	include("more_template/transplant.jl")

end

module more_tensor

	include("more_tensor/convert.jl")

	include("more_tensor/cumulate_sum_reverse.jl")

	include("more_tensor/get_area.jl")

	include("more_tensor/get_extreme.jl")

	include("more_tensor/make_increasing_by_stepping_down!.jl")

	include("more_tensor/make_increasing_by_stepping_up!.jl")

	include("more_tensor/shift_minimum.jl")

	include("more_tensor/sum_where.jl")

end

module more_vector

	include("more_vector/get_longest_common_prefix.jl")

	include("more_vector/get_order.jl")

	include("more_vector/is_in.jl")

	include("more_vector/sort_like.jl")

end

module io_fcs

	include("io_fcs/read.jl")

end

module io_gct

	include("io_gct/read.jl")

end

module io_gmt

	include("io_gmt/read.jl")

	include("io_gmt/write_txt.jl")

end

module io_pandas

	include("io_pandas/convert.jl")

	include("io_pandas/make_series.jl")

end

module io_table

	include("io_table/TableAccess.jl")

	include("io_table/read.jl")

	include("io_table/read_data.jl")

	include("io_table/read_gz.jl")

	include("io_table/read_xlsx.jl")

	include("io_table/write.jl")

end

module normalization

	include("normalization/normalize!.jl")

	include("normalization/normalize.jl")

end

module figure

	include("figure/plot.jl")

	include("figure/plot_bar.jl")

	include("figure/plot_heat_map.jl")

	include("figure/plot_x_y.jl")

	include("figure/write.jl")

end

module significance

	include("significance/adjust_p_value.jl")

	include("significance/get_family_wise_error_rate.jl")

	include("significance/get_margin_of_error.jl")

	include("significance/get_p_value.jl")

	include("significance/get_p_value_and_adjust.jl")

end

module feature_set_enrichment

	include("feature_set_enrichment/get_probability_and_cumulate.jl")

	include("feature_set_enrichment/make_benchmark.jl")

	include("feature_set_enrichment/plot_mountain.jl")

	include("feature_set_enrichment/score_set.jl")

	include("feature_set_enrichment/score_set_new.jl")

	include("feature_set_enrichment/try_method.jl")

end

module gene

	include("gene/data.jl")

	include("gene/make_string_to_ensembl_gene.jl")

	include("gene/make_string_to_hgnc_gene.jl")

	include("gene/map_mouse.jl")

	include("gene/map_to_column.jl")

	include("gene/read_ensembl.jl")

	include("gene/read_hgnc.jl")

	include("gene/rename.jl")

end

module emoji

	include("emoji/print_emoji.jl")

end

end

