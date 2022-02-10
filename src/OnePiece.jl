module OnePiece
module io
    module table
        include("io/table/_.jl")
        include("io/table/read.jl")
        include("io/table/write.jl")
    end
    module fcs
        include("io/fcs/_.jl")
        include("io/fcs/read.jl")
    end
    module gct
        include("io/gct/_.jl")
        include("io/gct/read.jl")
    end
    module gmt
        include("io/gmt/read.jl")
    end
end
module extension
    module constant
        include("extension/constant/ALPHABET.jl")
        include("extension/constant/CARD.jl")
    end
    module dict
        include("extension/dict/_.jl")
        include("extension/dict/make.jl")
        include("extension/dict/merge.jl")
        include("extension/dict/read.jl")
        include("extension/dict/sort_recursively!.jl")
        include("extension/dict/summarize.jl")
        include("extension/dict/symbolize_key.jl")
        include("extension/dict/view.jl")
        include("extension/dict/write.jl")
    end
    module vector
        include("extension/vector/get_longest_common_prefix.jl")
        include("extension/vector/get_order.jl")
        include("extension/vector/is_in.jl")
        include("extension/vector/sort_like.jl")
    end
    module string
        include("extension/string/_.jl")
        include("extension/string/remove_longest_common_prefix.jl")
        include("extension/string/replace.jl")
        include("extension/string/title.jl")
        include("extension/string/transplant.jl")
    end
    module path
        include("extension/path/_.jl")
        include("extension/path/clean.jl")
        include("extension/path/error_extension.jl")
        include("extension/path/error_missing_path.jl")
        include("extension/path/make_absolute.jl")
        include("extension/path/move.jl")
        include("extension/path/remove_extension.jl")
        include("extension/path/sed_recursively.jl")
        include("extension/path/select.jl")
        include("extension/path/shorten.jl")
    end
    module dataframe
        include("extension/dataframe/_.jl")
        include("extension/dataframe/map_to_column.jl")
    end
end
module templating
    include("templating/_.jl")
    include("templating/error_missing.jl")
    include("templating/plan_replacement.jl")
    include("templating/plan_transplant.jl")
    include("templating/transplant.jl")
end
module informatics
    module tensor
        include("informatics/tensor/cumulate_sum_reverse.jl")
        include("informatics/tensor/get_area.jl")
        include("informatics/tensor/get_extreme.jl")
        include("informatics/tensor/make_increasing_by_stepping_down!.jl")
        include("informatics/tensor/make_increasing_by_stepping_up!.jl")
        include("informatics/tensor/shift_minimum.jl")
        include("informatics/tensor/sum_where.jl")
    end
    module geometry
        include("informatics/geometry/get_center.jl")
    end
    module normalization
        include("informatics/normalization/_.jl")
        include("informatics/normalization/normalize!.jl")
        include("informatics/normalization/normalize.jl")
    end
    module statistics
        include("informatics/statistics/_.jl")
        include("informatics/statistics/get_confidence_interval.jl")
        include("informatics/statistics/get_z_score.jl")
    end
    module significance
        include("informatics/significance/_.jl")
        include("informatics/significance/adjust_p_value.jl")
        include("informatics/significance/get_margin_of_error.jl")
        include("informatics/significance/get_p_value.jl")
        include("informatics/significance/get_p_value_and_adjust.jl")
    end
    module information
        include("informatics/information/_.jl")
        include("informatics/information/get_entropy.jl")
        include("informatics/information/get_information_coefficient.jl")
        include("informatics/information/get_jensen_shannon_divergence.jl")
        include("informatics/information/get_kolmogorov_smirnov_statistic.jl")
        include("informatics/information/get_kullback_leibler_divergence.jl")
        include("informatics/information/get_kwat_pablo_divergence.jl")
        include("informatics/information/get_mutual_information.jl")
        include("informatics/information/get_signal_to_noise_ratio.jl")
        include("informatics/information/get_symmetric_information_sum.jl")
        include("informatics/information/get_thermodynamic_depth.jl")
    end
end
module emoji
    include("emoji/print.jl")
end
module figure
    include("figure/_.jl")
    include("figure/make_empty_trace.jl")
    include("figure/plot.jl")
    include("figure/plot_bar.jl")
    include("figure/plot_heat_map.jl")
    include("figure/plot_x_y.jl")
    include("figure/plot_y.jl")
    include("figure/write.jl")
end
module tensor_function
    include("tensor_function/apply.jl")
end
module feature_by_sample
    include("feature_by_sample/_.jl")
    include("feature_by_sample/compare_with_target.jl")
end
module gene
    include("gene/_.jl")
    include("gene/map_to_ensembl_gene.jl")
    include("gene/map_to_hgnc_gene.jl")
    include("gene/map_with_mouse.jl")
    include("gene/read_ensembl.jl")
    include("gene/read_hgnc.jl")
    include("gene/rename.jl")
end
module feature_set_enrichment
    include("feature_set_enrichment/_.jl")
    include("feature_set_enrichment/get_probability_and_cumulate.jl")
    include("feature_set_enrichment/make_benchmark.jl")
    include("feature_set_enrichment/plot_mountain.jl")
    include("feature_set_enrichment/score_set.jl")
    include("feature_set_enrichment/score_set_new.jl")
    include("feature_set_enrichment/sum_1_absolute_and_0_sum.jl")
    include("feature_set_enrichment/try_method.jl")
end
end
