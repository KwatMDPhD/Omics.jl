TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
jl_ = []

for (ro, di_, fi_) in walkdir(@__DIR__, topdown = false)

    for fi in fi_

        if endswith(fi, ".jl") && !(startswith(fi, "_") || startswith(fi, "runtests"))

            push!(jl_, joinpath(ro, fi))

        end

    end

end

# ----------------------------------------------------------------------------------------------- #
for (id, jl) in enumerate(jl_)

    if id < 1

        continue

    end

    println("($id) Running $jl")

    run(`julia --project $jl`)

end

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
