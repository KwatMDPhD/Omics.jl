function test()

    println("Testing environment...\n")

    for pr::String in (
        "skewer",
        "fastqc",
        "bgzip",
        "tabix",
        "minimap2",
        "samtools",
        "bcftools",
        "kallisto",
    )
        run(`which $pr`)

    end

    for pr::String in (
        "configManta.py",
        "configureStrelkaGermlineWorkflow.py",
        "configureStrelkaSomaticWorkflow.py",
    )
        run(`bash -c "source activate py2 && which $pr"`)

    end

end

export test
