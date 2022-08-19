function _add!(ve)

    if !(ve in VERTEX_)

        push!(VERTEX_, ve)

    end

end

function _add!(ed...)

    if !(ed in EDGE_)

        for ve in ed

            _add!(ve)

        end

        push!(EDGE_, ed)

    end

end
