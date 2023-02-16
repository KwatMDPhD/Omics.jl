function limit(st, n)

    if n < length(st)

        return "$(st[1:n])..."

    else

        return st

    end

end
