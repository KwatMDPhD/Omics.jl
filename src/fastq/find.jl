using Dates

function find(pa::String)::Vector{String}

    st = now()

    println(st)

    n_fq = 0

    n_gz = 0

    fi_ = []

    naf_ = [".fastq", ".fq"]

    nag_ = ["fastq.gz", "fq.gz"]

    for (ro, di_, xx_) in walkdir(pa)

        for xx in xx_

            for na in naf_

                if endswith(xx, na) && !occursin(".md5", xx)

                    n_fq += 1

                end

            end

            for na in nag_

                if endswith(xx, na) && !occursin(".md5", xx)

                    n_gz += 1

                    push!(fi_, joinpath(ro, xx))

                end

            end

        end

    end

    println(
        "Number of .fastq or .fq files found in directories walked: $n_fq\n",
    )

    println(
        "Number of fastq.gz or fq.gz files found in directories walked: $n_gz\n",
    )

    en = now()

    println(en)

    println(canonicalize(Dates.CompoundPeriod(en - st)))

    return fi_

end

export find
