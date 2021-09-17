module Kwat

module dictionary

include("dictionary/merge.jl")

end

module fastq

include("fastq/check.jl")

include("fastq/call_variant.jl")

include("fastq/check.jl")

include("fastq/concatenate.jl")

include("fastq/count_transcript.jl")

include("fastq/find.jl")

include("fastq/process_dna.jl")

include("fastq/process_soma_dna.jl")

include("fastq/run_command.jl")

include("fastq/test.jl")

include("fastq/trim.jl")

end

module file

include("file/read_gct.jl")

include("file/read_gmt.jl")

include("file/read_json.jl")

include("file/read_table.jl")

include("file/read_table_gz.jl")

include("file/read_xlsx.jl")

end

module information

include("information/get_ic.jl")

include("information/get_ided.jl")

include("information/get_ides.jl")

include("information/get_idrd.jl")

include("information/get_idrs.jl")

include("information/get_kld.jl")

include("information/get_mi.jl")

include("information/get_s.jl")

end

module math

include("math/get_center.jl")

end

module matrix_number

include("matrix_number/convert.jl")

end

module network

include("network/plot_network.jl")

end

module path

include("path/read_directory.jl")

end

module plot

include("plot/plot_x_y.jl")

include("plot/use_style!.jl")

end

module string

include("string/replace.jl")

include("string/title.jl")

end

module vector

include("vector/check_in.jl")

include("vector/list_card.jl")

include("vector/sort_like.jl")

end

module vector_number

include("vector_number/convert.jl")

include("vector_number/cumulate_sum_reverse.jl")

include("vector_number/get_area.jl")

include("vector_number/get_extreme.jl")

include("vector_number/normalize!.jl")

include("vector_number/normalize.jl")

include("vector_number/shift_minimum.jl")

include("vector_number/sum_where.jl")

end

module feature_set_enrichment

include("feature_set_enrichment/make_benchmark.jl")

include("feature_set_enrichment/plot_mountain.jl")

include("feature_set_enrichment/score_set.jl")

include("feature_set_enrichment/score_set_new.jl")

include("feature_set_enrichment/sum_1_absolute_and_n_0.jl")

include("feature_set_enrichment/compare_algorithms.jl")

end

end
