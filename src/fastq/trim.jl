using Dates: now, CompoundPeriod

function trim(
    fq1::String,
    fq2::String,
    pa::String,
    n_jo::Int,
    ad::String = "AGATCGGAAGAGC",
)::Nothing

    println("($st) Trimming")

    st = now()

    println(st)

    mkpath(pa)

    run_command(
        `skewer --threads $n_jo -x $ad --mode pe --mean-quality 10 --end-quality 10 --compress --output $pa --quiet $fq1 $fq2`,
    )

    en = now()

    println(en)

    println(canonicalize(Dates.CompoundPeriod(en - st)))

    return nothing

end

export trim
