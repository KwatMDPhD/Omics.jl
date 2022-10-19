function sort_recursively(an)

    if an isa AbstractArray

        [sort_recursively(an2) for an2 in an]

    elseif an isa AbstractDict

        sort(Base.Dict(ke => sort_recursively(va) for (ke, va) in an))

    else

        an

    end

end
