function >>(ve1, ve2)

    _add!(ve1, ve2)

    ve2

end

function >>(ve1_::Vector, ve2)

    for ve1 in ve1_

        _add!(ve1, ve2)

    end

    ve2

end

function >>(ve1, ve2_::Vector)

    for ve2 in ve2_

        _add!(ve1, ve2)

    end

    ve2_

end

function _make_ve2(ve1, ed)

    "$ve1.$ed"

end

function _make_ve2(ve1_::Vector, ed)

    _make_ve2(join(ve1_, "_"), ed)

end

function potentiate(ve1, ed, ve3)

    ve1 >> _make_ve2(ve1, ed) >> ve3

end

function >>(ve1::Union{DataType, Vector{DataType}}, ve3::Union{DataType, Vector{DataType}})

    potentiate(ve1, "in", ve3)

end

function <<(ve1::Union{DataType, Vector{DataType}}, ve3::Union{DataType, Vector{DataType}})

    potentiate(ve1, "de", ve3)

end
