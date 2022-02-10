function sort_recursively!(an)

    if an isa AbstractArray

        return sort_recursively!.(an)

    elseif an isa AbstractDict

        for (ke, va) in an

            an[ke] = sort_recursively!(va)

        end

        return sort!(OrderedDict(an))

    else

        return an

    end

end
