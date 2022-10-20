function split_and_get(st, de, id)

    li = id

    if id == 1

        li = 2

    end

    split(st, de, limit = li)[id]

end
