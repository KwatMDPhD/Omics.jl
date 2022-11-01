function print(ro_x_co_x_an, n_ro = 3, n_co = 3)

    if isempty(ro_x_co_x_an)

        error()

    end

    sir, sic = size(ro_x_co_x_an)

    println("Size: $sir x $sic")

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

        println("$idr_ x $idc_\n$(ro_x_co_x_an[idr_, idc_])")

    end

end
