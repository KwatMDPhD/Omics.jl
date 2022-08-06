function add(ve)

    if !(ve in VE_)

        push!(VE_, ve)

    end

end

function add(ve1, ve2)

    ed = (ve1, ve2)

    # TODO: Consider delegating
    for ve in ed

        add(ve)

    end

    if !(ed in ED_)

        push!(ED_, ed)

    end

end
