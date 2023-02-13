module BioLab

macro include()

    di, fi = splitdir(string(__source__.file))

    esc(quote

        for na in readdir($di)

            if (na != $fi) && endswith(na, ".jl")

                include(na)

            end

        end

    end)

end

for pa in readdir(@__DIR__; join = true)

    if isdir(pa)

        include(joinpath(basename(pa), "_.jl"))

    end

end

const TE = BioLab.Path.make_temporary("BioLab")

function __init__()

    mkpath(TE)

    ENV["LINES"] = 40

    ENV["COLUMNS"] = 80

    nothing

end

end
