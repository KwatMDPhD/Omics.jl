function rename(
    st_::Vector{String};
    mo::Bool = true,
    en::Bool = true,
    hg::Bool = true,
)::Tuple{Vector{String},Vector{Int64}}

    st_na = Dict{String,String}()

    if mo

        merge!(st_na, map_mouse())

    end

    if en

        merge!(st_na, make_string_to_ensembl_gene())

    end

    if hg

        merge!(st_na, make_string_to_hgnc_gene())

    end

    na_ = Vector{String}()

    ma_ = Vector{Int64}()

    for st in st_

        if haskey(st_na, st)

            na = st_na[st]

            ma = 1 - convert(Int64, st == na)

            push!(na_, na)

            push!(ma_, ma)

        else

            push!(na_, st)

            push!(ma_, 2)

        end

    end

    println("Kept ", count(ma_ .== 0))

    println("Named ", count(ma_ .== 1))

    println("Failed ", count(ma_ .== 2))

    return na_, ma_

end
