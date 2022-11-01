function write(js, ke_va)

    open(js, "w") do io

        JSON_print(io, ke_va, 2)

    end

end
