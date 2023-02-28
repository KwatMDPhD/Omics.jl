display([1 2; 3 4])

using Test

te = @__DIR__

sr = joinpath(dirname(te), "src")

function _get_prefix(na)

    return splitext(na)[1]

end

nb_ = [na for na in readdir(te) if endswith(na, r"\.ipynb$") && na != "runtests.ipynb"]

display(
    symdiff(
        (_get_prefix(na) for na in readdir(sr) if endswith(na, r"\.jl$") && na != "BioLab.jl"),
        (_get_prefix(nb) for nb in nb_),
    ),
)

using BioLab

# TODO: `@test`.

@test BioLab.RA == 20121020

@test BioLab.CA_ == ['A', '2', '3', '4', '5', '6', '7', '8', '9', 'X', 'J', 'Q', 'K']

@test basename(BioLab.TE) == "BioLab" && isdir(BioLab.TE) && isempty(readdir(BioLab.TE))

for pr in (true, false)

    BioLab.check_print(pr, "Aa", 2)

end

# @code_warntype BioLab.check_print(true, "Aa", 2)

BioLab.print_header()

st = "Hello World!"

BioLab.print_header(st)

# @code_warntype BioLab.print_header(st)

@test BioLab.@check_error error()

ig_ = [
    "Array.ipynb",
    "Clustering.ipynb",
    "Collection.ipynb",
    "DataFrame.ipynb",
    "Dict.ipynb",
    "FeatureSetEnrichment.ipynb",
    "FeatureXSample.ipynb",
    "GCT.ipynb",
    "GEO.ipynb",
    "GMT.ipynb",
    "Gene.ipynb",
    "HTML.ipynb",
    "IPYNB.ipynb",
    "Information.ipynb",
    "Match.ipynb",
    "Matrix.ipynb",
    "MatrixFactorization.ipynb",
    "Network.ipynb",
    "Normalization.ipynb",
    "Number.ipynb",
    "Path.ipynb",
    "Plot.ipynb",
    "Significance.ipynb",
    "Statistics.ipynb",
    "String.ipynb",
    "Table.ipynb",
    "Time.ipynb",
    "VectorNumber.ipynb",
]

@test ig_ == nb_

pushfirst!(ig_, "runtests.ipynb")

BioLab.IPYNB.run(@__DIR__, ig_[1:1])
