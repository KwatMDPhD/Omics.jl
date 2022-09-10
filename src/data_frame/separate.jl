function separate(da)

    co_ = names(da)

    co_[1], da[!, 1], co_[2:end], Matrix(da[!, 2:end])

end
