function map_protein()

    pr_x_in_x_an = OnePiece.Table.read(_path("uniprot.tsv.gz"))

    pr_io_an = Dict()

    in_ = names(pr_x_in_x_an)

    for an_ in eachrow(pr_x_in_x_an)

        io_an = Dict()

        for (io, an) in zip(in_, an_)

            if io == "Entry Name"

                OnePiece.Dict.set!(
                    pr_io_an,
                    (OnePiece.String.split_and_get(an, "_HUMAN", 1), io_an),
                )

            else

                if an isa AbstractString

                    if io == "Gene Names"

                        an = split(an, " ")

                    elseif io == "Interacts with"

                        an = split(an, "; ")

                    end

                end

                io_an[io] = an

            end

        end

    end

    pr_io_an

end
