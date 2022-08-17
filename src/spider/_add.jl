function _add(ve)

    if ve in VERTEX_

        #println("$ve has already been added.")

    else

        push!(VERTEX_, ve)

    end

end

function _add(ed...)

    if ed in EDGE_

        #println("$ed has already been added.")

    else

        for ve in ed

            _add(ve)

        end

        push!(EDGE_, ed)

    end

end
