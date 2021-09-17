using Dates: now, CompoundPeriod

function align(
    mo::String,
    fq1::String,
    fq2::String,
    sa::String,
    fa::String,
    pa::String,
    n_jo::Int,
    me::Int,
)

    st = now()
    
    paa = splitdir(pa)[1]
    
    id::String = "$fa.mmi"
    
    if isdir(paa)
         
        println("Skipping alignment because directory already exists: \n$paa")
        
    else
        
        println("($st) Aligning sequence ...")
        
        if !ispath(id)

            run_command(`minimap2 -t $n_jo -d $id $fa`)

        end
        
        mkpath(paa)
        
        if mo == "dna"
        
            run_command(
                pipeline(
                    `minimap2 -x sr -t $n_jo -K $(me)G -R "@RG\tID:$sa\tSM:$sa" -a $id $fq1 $fq2`,
                    `samtools sort --threads $n_jo -n`,
                    `samtools fixmate --threads $n_jo -m - -`,
                    `samtools sort --threads $n_jo`,
                    "$pa.tmp",
                ),
            )
        
        elseif mo == "cdna"
                
            run_command(
                pipeline(
                    `minimap2 -ax splice -uf -t $n_jo -K $(me)G -R "@RG\tID:$sa\tSM:$sa" -a $id $fq1 $fq2`,
                    `samtools sort --threads $n_jo -n`,
                    `samtools fixmate --threads $n_jo -m - -`,
                    `samtools sort --threads $n_jo`,
                    "$pa.tmp",
                ),
            )
            
        end

        run_command(`samtools markdup --threads $n_jo -s $pa.tmp $pa`)

        rm("$pa.tmp")

        run_command(`samtools index -@ $n_jo $pa`)

        run_command(pipeline(`samtools flagstat --threads $n_jo $pa`, "$pa.flagstat"))

    end
        
    en = now()

    println("Done at $en in $(canonicalize(Dates.CompoundPeriod(en - st))).\n")

end

export align
