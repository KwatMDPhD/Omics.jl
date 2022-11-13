function sort_recursively(an)

    if an isa AbstractArray

        ans = [sort_recursively(an2) for an2 in an]

    elseif an isa AbstractDict

        ans = sort(OrderedDict(ke => sort_recursively(va) for (ke, va) in an))

    else

        ans = an

    end

    try

        sort!(ans)

    catch

    end

    ans

end
