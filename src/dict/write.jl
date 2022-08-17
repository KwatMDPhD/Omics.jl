function write(pa, di; id = INDENT)

    open(pa, "w") do io

        JSON.print(io, di, id)

    end

end
