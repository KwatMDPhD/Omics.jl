sr = joinpath(dirname(@__DIR__), "src")

sr_ = [na for na in readdir(sr)]

ic_ = [
    dirname(split(li, "\"")[2]) for
    li in readlines(joinpath(sr, "OnePiece.jl")) if occursin("include", li)
]

symdiff(sr_, ic_)

te_ = [splitext(na)[1] for na in readdir() if endswith(na, ".ipynb")]

symdiff(sr_, te_)

using OnePiece

OnePiece.ipynb.run(@__DIR__, ["runtests.ipynb"])
