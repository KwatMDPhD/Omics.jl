function add(ve)

    if ve in VE_

        println("$ve has already been added.")

    else

        push!(VE_, ve)

    end

end

function add(ed...)

    if ed in ED_

        println("$ed has already been added.")

    else

        for ve in ed

            add(ve)

        end

        push!(ED_, ed)

    end

end
