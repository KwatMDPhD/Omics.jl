function write(pa, pl, he, wi, sc)

    open(pa, "w") do io

        savefig(
            io,
            pl;
            height = he,
            width = wi,
            scale = sc,
            format = splitext(pa)[end][2:end],
        )

    end

end
