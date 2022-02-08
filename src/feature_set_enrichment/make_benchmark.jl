function make_benchmark(ho)

    sp_ = split(ho)

    if sp_[1] == "card"

        fe_ = string.(CARD)

        n_fe = length(fe_)

        mi = convert(Int, ceil(n_fe / 2))

        sc_ = convert(Vector{Float64}, (mi - n_fe):(mi - 1))

        fe1_ = string.(collect(sp_[2]))

        if !all(fe1 in fe_ for fe1 in fe1_)

            error("not all cards are in the cards.")

        end

    elseif sp_[1] == "random"

        fe_ = [string("Feature ", id) for id in 1:parse(Int, sp_[2])]

        n_fe = length(fe_)

        mi = convert(Int, ceil(n_fe / 2))

        ha = randn(mi)

        sc_ = sort([.-ha[1:(n_fe - mi)]; ha])

        fe1_ = sample(fe_, parse(Int, sp_[3]); replace = false)

    elseif sp_[1] == "myc"

        di = joinpath(dirname(dirname(@__DIR__)), "test", "feature_set_enrichment.data")

        da = table_read(joinpath(di, "gene_score.tsv"))

        fe_ = string.(da[!, "Gene"])

        sc_ = da[!, "Score"]

        fe1_ = string.(gmt_read(joinpath(di, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"])

    end

    return fe_, sc_, fe1_

end
