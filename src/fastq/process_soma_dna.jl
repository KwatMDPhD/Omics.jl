function process_soma_dna(
    ge1::String,
    ge2::String,
    so1::String,
    so2::String,
    ta::Bool,
    paou::String,
    fa::String,
    chsi::String,
    chna::String,
    n_jo::Int,
    meto::Int,
    mejo::Int,
    snpeff::String,
)

    for file_path in [ge1, ge2, so1, so2, fa, chsi, chna]

        if !isfile(file_path)

            error("$file_path doesn't exist.")

        end

    end

    pagetr = joinpath(paou, "trim_sequence", "germ")

    trim_sequence(ge1, ge2, paou, pagetr, n_jo)

    ge1tr = "$pagetr-trimmed-pair1.fastq.gz"

    ge2tr = "$pagetr-trimmed-pair2.fastq.gz"

    pasotr = joinpath(paou, "trim_sequence", "soma")

    trim_sequence(so1, so2, pasotr, n_jo)

    so1tr = "$pasotr-trimmed-pair1.fastq.gz"

    so2tr = "$pasotr-trimmed-pair2.fastq.gz"

    check_read([ge1tr, ge2tr, so1tr, so2tr], joinpath(paou, "check_raw"), n_jo)

    pageal = joinpath(paou, "align_sequence", "germ.bam")

    align_sequence(ge1tr, ge2tr, "Germ", fa, pageal, n_jo, mejo)

    pasoal = joinpath(paou, "align_sequence", "soma.bam")

    align_sequence(so1tr, so2tr, "Soma", fa, pasoal, n_jo, mejo)

    sp = splitext(fa)[1]

    fagz = "$sp.bgz"

    if !isfile(fagz)

        run_command(
            pipeline(
                `gzip --decompress $fa --stdout`,
                `bgzip --threads $n_jo --stdout`,
                fagz,
            ),
        )

    end

    pava = joinpath(paou, "find_variant")

    return find_variant(
        pageal,
        pasoal,
        ta,
        fagz,
        chsi,
        chna,
        pava,
        n_jo,
        meto,
        snpeff,
    )

end

export process_soma_dna
