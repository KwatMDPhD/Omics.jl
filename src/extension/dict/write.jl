function write(pa, di; id = 3)

    open(pa, "w") do io

        return print(io, di, id)

    end

end
