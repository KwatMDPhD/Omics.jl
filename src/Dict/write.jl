function write(js, di)

    open(js, "w") do io

        JSON_print(io, di, 2)

    end

end
