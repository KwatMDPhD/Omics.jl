function error_missing(ro, pa_)

    mi_ = [pa for pa in joinpath.(ro, pa_) if !ispath(pa)]

    if !isempty(mi_)

        error(mi_)

    end

end
