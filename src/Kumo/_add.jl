function _add(ve)

    if !(ve in VE_)

        push!(VE_, ve)

    end

end

function _add(so, de)

    ed = (so, de)

    if !(ed in ED_)

        for ve in ed

            _add(ve)

        end

        push!(ED_, ed)

    end

end
