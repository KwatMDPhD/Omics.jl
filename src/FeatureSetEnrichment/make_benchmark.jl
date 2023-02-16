function make_benchmark(ho)

    sp_ = split(ho)

    if sp_[1] == "card"

        fe_ = [string(ca) for ca in BioLab.Constant.CA_]

        n = 13

        mi = cld(n, 2)

        sc_ = convert(Vector{Float64}, collect((mi - n):(mi - 1)))

        fe1_ = [string(ca) for ca in collect(sp_[2])]

        if !all(BioLab.Vector.is_in(fe1_, fe_))

            error()

        end

    elseif sp_[1] == "random"

        n = parse(Int, sp_[2])

        fe_ = ["Feature $id" for id in 1:n]

        sc_ = BioLab.VectorNumber.simulate(cld(n, 2), iseven(n))

        fe1_ = sample(fe_, parse(Int, sp_[3]); replace = false)

    elseif sp_[1] == "myc"

        di = joinpath(pkgdir(BioLab), "test", "FeatureSetEnrichment.data")

        da = BioLab.Table.read(joinpath(di, "gene_x_statistic_x_number.tsv"))

        fe_ = da[!, 1]

        sc_ = da[!, 2]

        fe1_ = BioLab.GMT.read(joinpath(di, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

    else

        error()

    end

    return fe_, sc_, fe1_

end
