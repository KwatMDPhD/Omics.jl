module Matrix

using ..BioLab

function print(ro_x_co_x_an; n_ro = 3, n_co = 3)

    sir, sic = size(ro_x_co_x_an)

    BioLab.print_header("$sir x $sic")

    if sir <= n_ro

        idr___ = (1:sir,)

    else

        idr___ = (1:n_ro, (sir - n_ro + 1):sir)

    end

    if sic <= n_co

        idc___ = (1:sic,)

    else

        idc___ = (1:n_co, (sic - n_co + 1):sic)

    end

    for idc_ in idc___, idr_ in idr___

        println("$idr_ x $idc_")

        display(view(ro_x_co_x_an, idr_, idc_))

    end

end

function make(an___)

    BioLab.Array.error_size(an___)

    n_ro = length(an___)

    n_co = length(an___[1])

    ro_x_co_x_an = Base.Matrix{BioLab.Collection.get_type(an___)}(undef, (n_ro, n_co))

    for idr in 1:n_ro, idc in 1:n_co

        ro_x_co_x_an[idr, idc] = an___[idr][idc]

    end

    ro_x_co_x_an

end

end
