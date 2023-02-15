function normalize_with_01!(te)

    mi = minimum(te)

    ra = maximum(te) - mi

    for (id, nu) in enumerate(te)

        te[id] = (nu - mi) / ra

    end

    nothing

end

function normalize_with_0!(te)

    me = mean(te)

    st = std(te)

    if st == 0

        error()

    end

    for (id, nu) in enumerate(te)

        te[id] = (nu - me) / st

    end

    nothing

end

function normalize_with_sum!(te)

    if any(nu < 0.0 for nu in te)

        error()

    end

    te ./= sum(te)

    nothing

end

function normalize_with_1234(te)

    ordinalrank(te)

end

function normalize_with_1223(te)

    denserank(te)

end

function normalize_with_1224(te)

    competerank(te)

end

function normalize_with_125254(te)

    tiedrank(te)

end
