module Time

using Dates: format, now

function stamp()

    format(now(), "Y_m_d_H_M_S_s")

end

end
