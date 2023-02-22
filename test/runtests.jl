te = @__DIR__

sr = joinpath(dirname(te), "src")

_get_prefix(na) = splitext(na)[1]

display(
    symdiff(
        (_get_prefix(na) for na in readdir(sr) if endswith(na, r"\.jl$") && na != "BioLab.jl"),
        (
            _get_prefix(na) for
            na in readdir(te) if endswith(na, r"\.ipynb$") && na != "runtests.ipynb"
        ),
    ),
)

using BioLab

# TODO: `@test`.
display(BioLab.TE)

# TODO: `@test`.
display(BioLab.CA_)

# TODO: `@test`.
display(BioLab.RA)

ig_ = (
    "runtests",
    (_get_prefix(na) for na in readdir() if contains(na, r"^_") && contains(na, r"\.ipynb$"))...,
)

# ig_ = (
# "runtests.ipynb",
# "Array.ipynb",
# "Clustering.ipynb",
# "Collection.ipynb",
# "DataFrame.ipynb",
# "Dict.data",
# "Dict.ipynb",
# "FeatureSetEnrichment.data",
# "FeatureSetEnrichment.ipynb",
# "FeatureXSample.ipynb",
# "GCT.data",
# "GCT.ipynb",
# "GEO.ipynb",
# "GMT.data",
# "GMT.ipynb",
# "Gene.ipynb",
# "HTML.ipynb",
# "IPYNB.ipynb",
# "Information.ipynb",
# "Matrix.ipynb",
# "MatrixFactorization.ipynb",
# "Network.ipynb",
# "Normalization.ipynb",
# "Number.ipynb",
# "Path.ipynb",
# "Plot.ipynb",
# "Significance.ipynb",
# "Statistics.ipynb",
# "String.ipynb",
# "Table.data",
# "Table.ipynb",
# "Time.ipynb",
# "VectorNumber.ipynb",
# )

BioLab.IPYNB.run(@__DIR__, ig_)
