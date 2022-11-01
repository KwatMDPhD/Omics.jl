macro _include()

    fi = string(__source__.file)

    :(_include($fi))

end

function _include(fi)

    di, fi = splitdir(fi)

    for na in readdir(di)

        if (na != fi) && endswith(na, ".jl")

            include(na)

        end

    end

end
