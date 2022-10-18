function sort_recursively!(an)

    if an isa AbstractArray

        sort_recursively!.(an)

    elseif an isa AbstractDict

        for (ke, va) in an

            an[ke] = sort_recursively!(va)

        end

        sort(an)

    else

        an

    end

end
