using DataIO: read_data
using Support: read_json

function load_benchmark(benchmark_directory_path)

    element_, score_ =
        eachcol(read_data(joinpath(benchmark_directory_path, "gene_x_score.tsv")))

    json_dict = read_json(joinpath(benchmark_directory_path, "gene_sets.json"))



    return element_,
    score_,
    read_gmt([
        joinpath(SETTING["gene_sets/"], gmt) for gmt in json_dict["gene_sets_tested"]
    ]),
    json_dict["gene_sets_positive"]

end
