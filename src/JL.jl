module JL

using ..BioLab

function run(jl)

    BioLab.print_header("🚆 Running $jl")

    Base.run(`julia --project $jl`)

    return nothing

end

function run(di, ig_)

    jl_ = BioLab.Path.list(di; jo = false, ig_, ke_ = (r".jl$",))

    if all(contains(jl, r"^[0-9]+\.") for jl in jl_)

        sort!(jl_; by = jl -> parse(Int, BioLab.String.split_and_get(jl, '.', 1)))

    end

    for jl in jl_

        run(joinpath(di, jl))

    end

    return nothing

end

end
