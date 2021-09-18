using Dates

function find(pa::String)

    st = now()

    n_fq = 0

    n_gz = 0

    fi_ = []
    
    naf_ = [".fastq", ".fq"]
    
    nag_ = ["fastq.gz", "fq.gz"]

    for (ro, di, th_) in walkdir("$pa")

        println("Walking sample directory: $ro\n")

        for th in th_
            
            for na in naf_ if endswith(th, na) && !occursin(".md5", th) 
                
                    n_fq += 1
                
                end

            end
            
            for na in nag_ if endswith(th, na) && !occursin(".md5", th)
            
                    n_gz += 1

                    push!(fi_, joinpath(ro, th))
                
                end
                
            end
            
        end          

    end

    println(
        "Number of .fastq or .fq files found in directories walked: $n_fq\n"
    )

    println(
        "Number of fastq.gz or fq.gz files found in directories walked: $n_gz\n",
    )

    en = now()

    println("Done at $en in $(canonicalize(Dates.CompoundPeriod(en - st))).\n")

    return fi_

end

export find