#
function >>(so, de)

    _add!(so, de)

    de

end

#
function >>(so_::AbstractVector, de)

    for so in so_

        so >> de

    end

    de

end

function >>(so, de_::AbstractVector)

    for de in de_

        so >> de

    end

    de_

end

#
function _make_vee(so, ed)

    "$so.$ed"

end

#
function _make_vee(so_::AbstractVector, ed)

    _make_vee(join(so_, "_"), ed)

end

#
function potentiate(so, ed, de)

    so >> _make_vee(so, ed) >> de

end

#
function >>(
    so::Union{DataType, AbstractVector{DataType}},
    de::Union{DataType, AbstractVector{DataType}},
)

    potentiate(so, "in", de)

end

function <<(
    so::Union{DataType, AbstractVector{DataType}},
    de::Union{DataType, AbstractVector{DataType}},
)

    potentiate(so, "de", de)

end
