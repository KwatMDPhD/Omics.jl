function split_and_get(st, de, id)

    return split(st, de; limit = id + 1)[id]

end
