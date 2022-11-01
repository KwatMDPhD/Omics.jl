function separate(ro_x_co_x_an)

    co_ = names(ro_x_co_x_an)

    co_[1], ro_x_co_x_an[!, 1], co_[2:end], Matrix(ro_x_co_x_an[!, 2:end])

end
