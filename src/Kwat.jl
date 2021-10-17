module Kwat

module applying

include("applying/apply.jl")

end

module bash

include("bash/run.jl")

end

module constant

include("constant/get_golden_ratio.jl")

include("constant/list_card.jl")

end

module dictionary

include("dictionary/make_keyword_argument.jl")

include("dictionary/merge.jl")

include("dictionary/summarize.jl")

end

module fastq

include("fastq/align.jl")

include("fastq/call_variant.jl")

include("fastq/check_read.jl")

include("fastq/concatenate.jl")

include("fastq/count_transcript.jl")

include("fastq/find.jl")

include("fastq/process_dna.jl")

include("fastq/process_soma_dna.jl")

include("fastq/test.jl")

include("fastq/trim.jl")

end

module figure

include("figure/plot.jl")

include("figure/plot_bar.jl")

include("figure/plot_heat_map.jl")

include("figure/plot_x_y.jl")

end

module gct

include("gct/read.jl")

end

module gmt

include("gmt/read.jl")

end

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

module json

include("json/read.jl")

include("json/write.jl")

end

module math

include("math/get_center.jl")

include("math/get_confidence_interval.jl")

include("math/get_z_score.jl")

end

module matrix_number

include("matrix_number/convert.jl")

end

module network

include("network/plot.jl")

end

module pandas

include("pandas/make_dataframe.jl")

include("pandas/make_series.jl")

end

module path

include("path/clean.jl")

include("path/get_absolute.jl")

include("path/get_download_directory.jl")

include("path/select.jl")

end

module string

include("string/replace.jl")

include("string/title.jl")

end

module table

include("table/read.jl")

include("table/read_gz.jl")

include("table/read_xlsx.jl")

include("table/write.jl")

end

module vector

include("vector/check_in.jl")

include("vector/sort_like.jl")

end

module vector_number

include("vector_number/convert.jl")

include("vector_number/cumulate_sum_reverse.jl")

include("vector_number/get_area.jl")

include("vector_number/get_extreme.jl")

include("vector_number/make_increasing_by_stepping_down!.jl")

include("vector_number/make_increasing_by_stepping_up!.jl")

include("vector_number/normalize!.jl")

include("vector_number/normalize.jl")

include("vector_number/shift_minimum.jl")

include("vector_number/sum_where.jl")

end

module workflow

include("workflow/get_path.jl")

end

module significance

include("significance/adjust_p_value.jl")

include("significance/get_family_wise_error_rate.jl")

include("significance/get_margin_of_error.jl")

include("significance/get_p_value.jl")

include("significance/get_p_value_and_adjust.jl")

end

module feature_by_sample

include("feature_by_sample/compare_with_target.jl")

end

module feature_set_enrichment

include("feature_set_enrichment/_get_probability_and_cumulative_probability.jl")

include("feature_set_enrichment/make_benchmark.jl")

include("feature_set_enrichment/plot_mountain.jl")

include("feature_set_enrichment/score_set.jl")

include("feature_set_enrichment/score_set_new.jl")

include("feature_set_enrichment/try_method.jl")

end

end
