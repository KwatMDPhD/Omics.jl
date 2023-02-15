function error_missing(di, pa_)

    if !isempty(pa for pa in pa_ if !ispath(joinpath(di, pa)))

        error()

    end

    nothing

end
