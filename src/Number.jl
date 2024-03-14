module Number

using Printf: @sprintf

using ..Nucleus

function format2(nu)

    @sprintf "%.2g" nu

end

function format4(nu)

    @sprintf "%.4g" nu

end

function categorize(nu, nu_, ca_)

    ca_[findfirst(>(nu), nu_) - 1]

end

function try_parse(st)

    try

        return convert(Int, parse(Float64, st))

    catch

    end

    try

        return parse(Float64, st)

    catch

    end

    st

end

function integize(an_)

    an_id = Nucleus.Collection._map_index(unique(an_))

    [an_id[an] for an in an_]

end

end
