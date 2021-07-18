function list_card()::Vector{String}

    return string.(collect("A23456789XJQK"))

end

export list_card
