using GCTGMT
using FeatureSetEnrichment

include("load_benchmark.jl")

function peek_benchmark(benchmark::String)::Nothing

    benchmark, set = split(benchmark, '.'; limit = 2)

    element_, score_, set_to_element_, benchmark_set_ =
        load_benchmark(joinpath(SETTING["benchmarks/"], benchmark))

    score_set_new(element_, score_, set_to_element_[set]; plot_process = false)

    return nothing

end
