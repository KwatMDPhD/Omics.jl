module OnePiece

for pa in readdir(@__DIR__, join = true)

    if isdir(pa)

        include(joinpath(basename(pa), "_.jl"))

    end

end

function __init__()

    global TEMPORARY_DIRECTORY = OnePiece.path.make_temporary("OnePiece")

    ENV["COLUMNS"] = 160

end

end
