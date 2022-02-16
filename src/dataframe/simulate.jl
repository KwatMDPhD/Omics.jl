function simulate(n_ro, n_co; co_ = ["Column$id" for id in 1:n_co])

    DataFrame(reshape(collect(1:(n_ro * n_co)), n_ro, n_co), co_)

end
