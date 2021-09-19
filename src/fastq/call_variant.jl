using Dates

function call_variant(
    mo::String,
    ge::Union{String,Nothing},
    so::Union{String,Nothing},
    ta::Bool,
    fa::String,
    chs::String,
    chn::String,
    pao::String,
    n_jo::Int,
    me::Int,
    pas::String,
)

    if !(isfile("$fa.fai") && ispath("$fa.gzi"))

        run_command(`samtools faidx $fa`)

    end

    if !ispath("$chs.tbi")

        run_command(`tabix --force $chs`)

    end


    # Set config parameters

    co::String = "--referenceFasta $fa --callRegions $chs"

    if ta

        co = "$co --exome"

    end

    if mo == "cdna"

        co = "$co --rna"

    end

    if ge != nothing && so != nothing

        co = "$co --normalBam $ge --tumorBam $so"

    elseif ge != nothing

        co = "$co --bam $ge"

    else

        error(
            "Specify germ and soma .bam for processing soma or germ .bam for processing germ.",
        )

    end


    # Set run parameters

    ru::String = "--mode local --jobs $n_jo --memGb $me --quiet"

    pav::String = joinpath("results", "variants")

    if mo == "dna"

        pam::String = joinpath(pao, "manta")

        run_command(
            `bash -c "source activate py2 && configManta.py $co --outputContig --runDir $pam && $(joinpath(pam, "runWorkflow.py")) $ru"`,
        )

    end

    past::String = joinpath(pao, "strelka")


    # Configure strelka

    local st::String

    if ge != nothing && so != nothing

        st = "configureStrelkaSomaticWorkflow.py $co --indelCandidates $(joinpath(pam, pav, "candidateSmallIndels.vcf.gz")) --runDir $past"

    else

        println("this is co right before strelka is configured: $co\n")

        st = "configureStrelkaGermlineWorkflow.py $co --runDir $past"

    end


    # Run strelka

    run_command(
        `bash -c "source activate py2 && $st && $(joinpath(past, "runWorkflow.py")) $ru"`,
    )


    if ge != nothing && so != nothing

        sa = joinpath(pao, "sample.txt")

        # TODO: get sample names (maybe from .bam) and use them instead of "Germ" and "Soma"

        open(io -> write(io, "Germ\nSoma"), sa; write = true)

        pain = joinpath(past, pav, "somatic.indels.vcf.gz")

        run_command(
            pipeline(`bcftools reheader --threads $n_jo --samples $sa $pain`, "$pain.tmp"),
        )

        mv("$pain.tmp", pain; force = true)

        run_command(`tabix --force $pain`)

        pasv::String = joinpath(past, pav, "somatic.snvs.vcf.gz")

        run_command(
            pipeline(`bcftools reheader --threads $n_jo --samples $sa $pasv`, "pasv.tmp"),
        )

        mv("$pasv.tmp", pasv; force = true)

        run_command(`tabix --force $pasv`)

        vc_ = [joinpath(pam, pav, "somaticSV.vcf.gz"), pain, pasv]

    elseif mo == "cdna"

        vc_ = [joinpath(past, pav, "variants.vcf.gz")]

        println("this is vc_: $vc_")


    else

        vc_ =
            [joinpath(pam, pav, "diploidSV.vcf.gz"), joinpath(past, pav, "variants.vcf.gz")]

    end

    paco::String = joinpath(pao, "concat.vcf.gz")

    run_command(
        pipeline(
            `bcftools concat --threads $n_jo --allow-overlaps $vc_`,
            `bcftools annotate --threads $n_jo --rename-chrs $chn`,
            `bgzip --threads $n_jo --stdout`,
            paco,
        ),
    )

    run_command(`tabix $paco`)

    sn::String = joinpath(pao, "snpeff")

    mkpath(sn)

    snvc::String = joinpath(sn, "snpeff.vcf.gz")

    run_command(
        pipeline(
            `java -Xmx$(me)g -jar $pas GRCh38.99 -noLog -verbose -csvStats $(joinpath(sn, "stats.csv")) -htmlStats $(joinpath(sn, "stats.html")) $paco`,
            `bgzip --threads $n_jo --stdout`,
            snvc,
        ),
    )

    run_command(`tabix $snvc`)

    ps::String = joinpath(pao, "pass.vcf.gz")

    run_command(
        pipeline(
            `bcftools view --threads $n_jo --include 'FILTER=="PASS"' $snvc`,
            `bgzip --threads $n_jo --stdout`,
            ps,
        ),
    )

    run_command(`tabix $ps`)

end

export call_variant
