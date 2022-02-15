function write(pa, di; id = 3)

    open(pa, "w") do io

        print(io, di, id)

    end

end
