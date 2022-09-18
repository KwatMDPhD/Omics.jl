module OnePiece

for pa in readdir(@__DIR__, join = true)

    if isdir(pa)

        include(joinpath(basename(pa), "_.jl"))

    end

end

function __init__()

    global TEMPORARY_DIRECTORY = OnePiece.path.make_temporary("OnePiece")

    ENV["LINES"] = Int(1e2)

    ENV["COLUMNS"] = Int(1e5)

end

end
