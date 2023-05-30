module Time

using Dates: format, now

function stamp()

    format(now(), "Y.m.d_H.M.S.s")

end

end
