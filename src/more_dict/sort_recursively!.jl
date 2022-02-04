using OrderedCollections: OrderedDict

function sort_recursively!(an::Any)::Any

    if an isa AbstractArray

        return [sort_recursively!(yy) for yy in an]

    elseif an isa AbstractDict

        for (ke, va) in an

            an[ke] = sort_recursively!(va)

        end

        return sort!(OrderedDict(an))

    else

        return an

    end

end
