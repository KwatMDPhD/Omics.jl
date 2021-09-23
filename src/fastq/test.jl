function test()::Nothing

    println("Testing")

    for pr in [
        "skewer",
        "fastqc",
        "bgzip",
        "tabix",
        "minimap2",
        "samtools",
        "bcftools",
        "kallisto",
    ]

        run(`which $pr`)

    end

    for pr in [
        "configManta.py",
        "configureStrelkaGermlineWorkflow.py",
        "configureStrelkaSomaticWorkflow.py",
    ]

        run(`bash -c "source activate py2 && which $pr"`)

    end

    return nothing

end

export test
