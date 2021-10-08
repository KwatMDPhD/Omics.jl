using Dates: now, CompoundPeriod

function check_read(fq_::Array, pa::String, n_jo::Int)

    st = now()

    if ispath(pa)

        println(
            "Skipping check sequence because directory already exists:\n $pa\n",
        )

    else

        println("($st) Checking sequence")

        mkpath(pa)

        run_command(
            `fastqc --threads $(minimum((length(fq_), n_jo))) --outdir $pa $fq_`,
        )

        println("Checking sequence bias ...")

        run_command(`multiqc --outdir $pa $pa`)

    end

    en = now()

    ti = canonicalize(Dates.CompoundPeriod(en - st))

    return println("Done at $en in $ti.\n")

end

export check_read
