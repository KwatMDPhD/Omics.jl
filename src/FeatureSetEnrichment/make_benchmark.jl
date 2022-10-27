function make_benchmark(ho)

    sp_ = split(ho)

    if sp_[1] == "card"

        fe_ = OnePiece.Constant.CA_

        n_fe = length(fe_)

        mi = ceil(Int, n_fe / 2)

        sc_ = convert(Vector{Float64}, (mi - n_fe):(mi - 1))

        fe1_ = [string(fe1) for fe1 in sp_[2]]

        if !all(fe1 in fe_ for fe1 in fe1_)

            error()

        end

    elseif sp_[1] == "random"

        fe_ = ["Feature $id" for id in 1:parse(Int, sp_[2])]

        sc_ = OnePiece.VectorNumber.simulate(length(fe_))

        fe1_ = sample(fe_, parse(Int, sp_[3]), replace = false)

    elseif sp_[1] == "myc"

        di = joinpath(dirname(dirname(@__DIR__)), "test", "FeatureSetEnrichment.data")

        da = OnePiece.Table.read(joinpath(di, "gene_score.tsv"))

        fe_ = convert(Vector{String}, da[!, "Gene"])

        sc_ = da[!, "Score"]

        fe1_ = convert(
            Vector{String},
            OnePiece.GMT.read(joinpath(di, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"],
        )

    else

        error()

    end

    fe_, sc_, fe1_

end
