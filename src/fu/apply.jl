function _process(an, te)

    an, te

end

function _process(bi_::AbstractVector{Bool}, te)

    te[.!bi_], te[bi_]

end

function apply(an, te, fu)

    fu(_process(an, te)...)

end

function apply(an, ma::AbstractMatrix, fu)

    [fu(_process(an, ro)...) for ro in eachrow(ma)]

end

function apply(ma1::AbstractMatrix, ma2::AbstractMatrix, fu)

    [fu(_process(ro1, ro2)...) for ro1 in eachrow(ma1), ro2 in eachrow(ma2)]

end
