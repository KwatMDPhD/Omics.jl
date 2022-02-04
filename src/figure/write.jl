using PlotlyJS: SyncPlot, savefig

function write(pa::String, pl::SyncPlot, he::Int, wi::Int, sc::Real)::Nothing

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

    return nothing

end
