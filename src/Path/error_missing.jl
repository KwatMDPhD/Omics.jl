function error_missing(ro, pa_)

    mi_ = [pa for pa in pa_ if !ispath(joinpath(ro, pa))]

    if !isempty(mi_)

        error(mi_)

    end

end
