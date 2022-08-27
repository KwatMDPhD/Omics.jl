function simulate(n_ro, n_co; ho = "1:")

    if ho == "1:"

        reshape(collect(1.0:(n_ro * n_co)), n_ro, n_co)

    elseif ho == "ra"

        rand(n_ro, n_co)

    end

end
