function _add!(ve)

    if !(ve in VERTEX_)

        push!(VERTEX_, ve)

    end

    VERTEX_

end

function _add!(so, de)

    ed = [so, de]

    if !(ed in EDGE_)

        for ve in ed

            _add!(ve)

        end

        push!(EDGE_, ed)

    end

    EDGE_

end
