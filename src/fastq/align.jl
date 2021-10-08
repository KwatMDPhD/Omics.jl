using Dates: now, CompoundPeriod

function align(
    mo::String,
    sa::String,
    fq1::String,
    fq2::String,
    fa::String,
    pa::String,
    n_jo::Int,
    me::Int,
)::Nothing

    println("Aligning")

    st = now()

    println(st)

    id = "$fa.mmi"

    if !ispath(id)

        run_command(`minimap2 -t $n_jo -d $id $fa`)

    end

    di = splitdir(pa)[1]

    mkpath(di)

    pi_ = [
        `samtools sort --threads $n_jo -n`,
        `samtools fixmate --threads $n_jo -m - -`,
        `samtools sort --threads $n_jo`,
        "$pa.tmp",
    ]

    if mo == "dna"

        run_command(
            pipeline(
                `minimap2 -x sr -t $n_jo -K $(me)G -R "@RG\tID:$sa\tSM:$sa" -a $id $fq1 $fq2`,
                pi_...,
            ),
        )

    elseif mo == "cdna"

        run_command(
            pipeline(
                `minimap2 -ax splice -uf -t $n_jo -K $(me)G -R "@RG\tID:$sa\tSM:$sa" -a $id $fq1 $fq2`,
                pi_...,
            ),
        )

    end

    run_command(`samtools markdup --threads $n_jo -s $pa.tmp $pa`)

    rm("$pa.tmp")

    run_command(`samtools index -@ $n_jo $pa`)

    run_command(
        pipeline(`samtools flagstat --threads $n_jo $pa`, "$pa.flagstat"),
    )

    en = now()

    println(en)

    println(canonicalize(Dates.CompoundPeriod(en - st)))

    return nothing

end

export align
