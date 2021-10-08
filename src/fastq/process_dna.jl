function process_dna(
    mo::String,
    fq1::String,
    fq2::String,
    ad::String,
    ta::Bool,
    pao::String,
    fa::String,
    chi::String,
    chn::String,
    pas::String,
    n_jo::Int,
    met::Int,
    mej::Int,
)

    for pa in [fq1, fq2, fa, chi, chn, pas]

        if !isfile(pa)

            error("$pa does not exist.")

        end

    end

    pat = joinpath(pao, "trim/")

    trim(fq1, fq2, pat, n_jo, ad)

    fq1t = joinpath(pat, "trimmed-pair1.fastq.gz")

    fq2t = joinpath(pat, "trimmed-pair2.fastq.gz")

    check([fq1t, fq2t], joinpath(pao, "check_trim"), n_jo)

    paa = joinpath(pao, "align", "germ.bam")

    align(mo, fq1t, fq2t, "Germ", fa, paa, n_jo, mej)

    sp = splitext(fa)[1]

    fag = "$sp.bgz"

    if !isfile(fag)

        run_command(
            pipeline(
                `gzip --decompress $fa --stdout`,
                `bgzip --threads $n_jo --stdout`,
                fag,
            ),
        )

    end

    pav = joinpath(pao, "call_variant")

    return call_variant(
        mo,
        paa,
        nothing,
        ta,
        fag,
        chi,
        chn,
        pav,
        n_jo,
        met,
        pas,
    )

end

export process_dna
