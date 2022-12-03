function _po(so, ho)

    "$so.$ho"

end

function _po(so_::AbstractVector, ho)

    _po(join(so_, "_"), ho)

end

function _potentiate(so, ho, de)

    _edge(_edge(so, _po(so, ho)), de)

end

function >>(
    so::Union{DataType, AbstractVector{DataType}},
    de::Union{DataType, AbstractVector{DataType}},
)

    _potentiate(so, "+", de)

end

function <<(
    so::Union{DataType, AbstractVector{DataType}},
    de::Union{DataType, AbstractVector{DataType}},
)

    _potentiate(so, "-", de)

end
