function make_benchmark(ho)

    sp_ = split(ho)

    if sp_[1] == "card"

        fe_ = OnePiece.Constant.CA_

        n = convert(Float64, length(fe_))

        mi = ceil(n / 2.0)

        sc_ = collect((mi - n):(mi - 1.0))

        fe1_ = convert(Vector{String}, split(sp_[2], ""))

        if !all(OnePiece.Vector.is_in(fe1, fe_))

            error()

        end

    elseif sp_[1] == "random"

        n = parse(Int, sp_[2])

        fe_ = ["Feature $id" for id in 1:n]

        sc_ = OnePiece.VectorNumber.simulate(ceil(Int, n / 2), iseven(n))

        fe1_ = sample(fe_, parse(Int, sp_[3]), replace = false)

    elseif sp_[1] == "myc"

        di = joinpath(dirname(dirname(@__DIR__)), "test", "FeatureSetEnrichment.data")

        da = OnePiece.Table.read(joinpath(di, "gene_x_statistic_x_number.tsv"))

        fe_ = convert(Vector{String}, da[!, 1])

        sc_ = da[!, 2]

        fe1_ = OnePiece.GMT.read(joinpath(di, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

    else

        error()

    end

    fe_, sc_, fe1_

end
