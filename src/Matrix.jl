module Matrix

using ..BioLab

function print(ro_x_co_x_an; n_ro = 3, n_co = 3)

    sir, sic = size(ro_x_co_x_an)

    println("📐 $sir x $sic")

    if sir <= n_ro

        idr__ = (1:sir,)

    else

        idr__ = (1:n_ro, (1 + sir - n_ro):sir)

    end

    if sic <= n_co

        idc__ = (1:sic,)

    else

        idc__ = (1:n_co, (1 + sic - n_co):sic)

    end

    for idr_ in idr__, idc_ in idc__

        println("🕯️ $idr_ x $idc_\n$(view(ro_x_co_x_an, idr_, idc_))")

    end

    return nothing

end

function _error_bad(an, ba_)

    for ba in ba_

        if isequal(an, ba)

            error(ba)

        end

    end

    return nothing

end

function error_bad(ro_x_co_x_an, ty)

    n_ro, n_co = size(ro_x_co_x_an)

    for idr in 1:n_ro, idc in 1:n_co

        an = ro_x_co_x_an[idr, idc]

        if !(an isa ty)

            error()

        end

        if ty <: Real

            ba_ = (-Inf, Inf, NaN)

        elseif ty <: AbstractString

            ba_ = ("",)

        end

        _error_bad(an, ba_)

    end

    return nothing

end

function make(an__)

    BioLab.Array.error_size(an__)

    n_ro = length(an__)

    n_co = length(an__[1])

    ro_x_co_x_an = Base.Matrix{BioLab.Collection.get_type(an__...)}(undef, (n_ro, n_co))

    for idr in 1:n_ro, idc in 1:n_co

        ro_x_co_x_an[idr, idc] = an__[idr][idc]

    end

    return ro_x_co_x_an

end

function apply_by_column!(ro_x_co_x_an, fu!)

    for ve in eachcol(ro_x_co_x_an)

        fu!(ve)

    end

    return nothing

end

function apply_by_row!(ro_x_co_x_an, fu!)

    for ve in eachrow(ro_x_co_x_an)

        fu!(ve)

    end

    return nothing

end

function simulate(n_ro, n_co, ho)

    if ho == "1.0:"

        return convert(Base.Matrix, reshape(1.0:(n_ro * n_co), (n_ro, n_co)))

    elseif ho == "rand"

        return rand(n_ro, n_co)

    else

        error()

    end

end

end
