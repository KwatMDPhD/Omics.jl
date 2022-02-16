function write(pa, di; id = IN)

    open(pa, "w") do io

        JSON.print(io, di, id)

    end

end
