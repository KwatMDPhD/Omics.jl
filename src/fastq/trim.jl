using Dates: now, CompoundPeriod

function trim(
    fq1::String, 
    fq2::String, 
    pa::String, 
    n_jo::Int,
    ad::String="AGATCGGAAGAGC"
    )

    st = now()

    pa1 = joinpath(string(pa), "trimmed-pair1.fastq.gz")

    pa2 = joinpath(string(pa), "trimmed-pair2.fastq.gz")

    if isfile(pa1) && isfile(pa2)

        println("Skipping trimming because trimmed files already exist:\n $pa1\n $pa2\n")

    else


        println("($st) Trimming sequence ...")

        mkpath(pa)
        
        println("Made path for trimmed files: $pa")

        run_command(
            `skewer --threads $n_jo -x $ad --mode pe --mean-quality 10 --end-quality 10 --compress --output $pa --quiet $fq1 $fq2`,
        )

        en = now()

        println("Done at $en in $(canonicalize(Dates.CompoundPeriod(en - st))).\n")

    end

end

export trim
