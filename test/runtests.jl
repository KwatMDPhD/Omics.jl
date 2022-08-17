sr = joinpath(dirname(@__DIR__), "src")

sr_ = [na for na in readdir(sr)]

te_ = [splitext(na)[1] for na in readdir() if endswith(na, ".ipynb")]

symdiff(sr_, te_)

using OnePiece

OnePiece.ipynb.run(@__DIR__, ["runtests.ipynb"])
