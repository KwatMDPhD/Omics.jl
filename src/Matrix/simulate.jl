function simulate(n_ro, n_co, ho)

    if ho == "1:"

        convert(Base.Matrix, reshape(1:(n_ro * n_co), (n_ro, n_co)))

    elseif ho == "rand"

        rand(n_ro, n_co)

    else

        error()

    end

end
