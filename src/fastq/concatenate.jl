using Dates: now, CompoundPeriod

function concatenate(fq_, sa::String, pa::String)

    st = now()

    fo_ = []

    re_ = []

    naf_ = ["R1", "_1", "read1"]

    nar_ = ["R2", "_2", "read2"]

    for fi in fq_

        for na in naf_

            if occursin(na, fi)

                push!(fo_, fi)

            end

        end

        for na in nar_

            if occursin(na, fi)

                push!(re_, fi)

            end

        end

    end

    n_fo = length(fo_)

    n_re = length(re_)

    println("Number of forward read files = $n_fo\n")

    println("Number of reverse read files = $n_re\n")

    paca = joinpath(pa, string(sa, "_cat"))

    if ispath(paca)

        println(
            "Skipping concatenation because directory already exists:\n $paca\n",
        )

    elseif n_fo <= 1 && n_re <= 1

        println(
            "Nothing to concatenate because number of forward reads ($n_fo) and number of reverse reads ($n_re) are <= 1.\n",
        )

    else

        run(pipeline(`mkdir $paca`))

        println("Combining forward reads...\n")

        run(
            pipeline(
                `cat $fo_`,
                stdout = joinpath(paca, string(sa, "_R1.fastq.gz")),
            ),
        )

        println("Combining reverse reads...\n")

        run(
            pipeline(
                `cat $re_`,
                stdout = joinpath(paca, string(sa, "_R2.fastq.gz")),
            ),
        )

        println("Concatenated files saved at $paca\n")

    end

    en = now()

    ti = canonicalize(Dates.CompoundPeriod(en - st))

    return println("Done at $en in $ti.\n")

end

export concatenate
