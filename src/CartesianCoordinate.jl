module CartesianCoordinate

using MultivariateStats: MetricMDS, fit

function ge(di)

    fit(MetricMDS, di; distances = true, maxoutdim = 2, maxiter = 1000).X

end

end
