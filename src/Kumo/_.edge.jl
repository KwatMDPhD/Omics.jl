function _edge(so, de)

    _add(so, de)

    de

end

function _edge(so_::AbstractVector, de)

    for so in so_

        _edge(so, de)

    end

    de

end

function _edge(so, de_::AbstractVector)

    for de in de_

        _edge(so, de)

    end

    de_

end
