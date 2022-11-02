#
function >>(so, de)

    _add!(so, de)

    de

end

#
function >>(so_::Vector, de)

    for so in so_

        so >> de

    end

end

function >>(so, de_::Vector)

    for de in de_

        so >> de

    end

end

#
function _make_vee(so, ed)

    "$so.$ed"

end

#
function _make_vee(so_::Vector, ed)

    _make_vee(join(so_, "_"), ed)

end

#
function potentiate(so, ed, de)

    so >> _make_vee(so, ed) >> de

end

#
function >>(so::Union{DataType, Vector{DataType}}, de::Union{DataType, Vector{DataType}})

    potentiate(so, "in", de)

end

function <<(so::Union{DataType, Vector{DataType}}, de::Union{DataType, Vector{DataType}})

    potentiate(so, "de", de)

end
