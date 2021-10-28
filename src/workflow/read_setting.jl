using ..json: read

function read_setting(pa::String)::Dict

    se = read(pa)

    di = dirname(pa)

    for (ke, va) in se

        if isa(va, String)

            va2 = replace(va, r"^\./" => string(di, "/"))

            if va != va2

                println(va, " ==> ", va2)

                se[ke] = va2

            end

        end

    end

    return se

end

export read_setting
