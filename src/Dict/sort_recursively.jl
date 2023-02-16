# TODO: Move elsewhere.
function sort_recursively(an)

    if an isa AbstractArray

        ans = [sort_recursively(an2) for an2 in an]

    elseif an isa AbstractDict

        ans = sort(OrderedDict(ke => sort_recursively(va) for (ke, va) in an))

    else

        ans = an

    end

    try

        if ans isa Tuple

            ans = Tuple(sort!(collect(ans)))

        end

        sort!(ans)

    catch

    end

    return ans

end
