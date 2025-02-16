module Normalization

using ..Omics

function do_0_clamp!(::AbstractVector{<:Integer}, ::Real) end

function do_0_clamp!(fl_, st)

    if allequal(fl_)

        @warn "All $(fl_[1])."

        fill!(fl_, 0.0)

    else

        clamp!(Omics.RangeNormalization.do_0!(fl_), -st, st)

    end

end

function do_125254_01!(fl_)

    Omics.RangeNormalization.do_01!(Omics.RankNormalization.do_125254!(fl_))

end

end
