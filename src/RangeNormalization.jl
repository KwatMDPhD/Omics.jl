module RangeNormalization

using StatsBase: mean, std

function shift!(nu_)

    mi = minimum(nu_)

    map!(nu -> nu - mi, nu_, nu_)

end

function shift_log2!(fl_, m1 = 1.0)

    m2 = minimum(fl_)

    map!(fl -> log2(fl - m2 + m1), fl_, fl_)

end

function do_0!(fl_)

    me = mean(fl_)

    iv = inv(std(fl_))

    map!(fl -> (fl - me) * iv, fl_, fl_)

end

function do_01!(fl_)

    mi, ma = extrema(fl_)

    iv = inv(ma - mi)

    map!(fl -> (fl - mi) * iv, fl_, fl_)

end

function do_sum!(fl_)

    iv = inv(sum(fl_))

    map!(fl -> fl * iv, fl_, fl_)

end

end
