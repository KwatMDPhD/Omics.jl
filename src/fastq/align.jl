function align(
    mo::String,
    sa::String,
    fq1::String,
    fq2::String,
    fa::String,
    pa::String,
    n_jo::Int64,
    me::Int64,
)::Nothing


    id = string(fa, ".mmi")

    if !ispath(id)

        run_command(`minimap2 -t $n_jo -d $id $fa`)

    end

    di = splitdir(pa)[1]

    mkpath(di)

    if mo == "dna"

        md = "-x sr"


    elseif mo == "cdna"

        md = "-ax splice -uf"

    end

    run_command(
        pipeline(
            `minimap2 $md -t $n_jo -K $(me)G -R "@RG\tID:$sa\tSM:$sa" -a $id $fq1 $fq2`,
            `samtools sort --threads $n_jo -n`,
            `samtools fixmate --threads $n_jo -m - -`,
            `samtools sort --threads $n_jo`,
            "$pa.tmp",
        ),
    )

    run_command(`samtools markdup --threads $n_jo -s $pa.tmp $pa`)

    rm("$pa.tmp")

    run_command(`samtools index -@ $n_jo $pa`)

    run_command(
        pipeline(`samtools flagstat --threads $n_jo $pa`, "$pa.flagstat"),
    )


    return nothing

end

export align
