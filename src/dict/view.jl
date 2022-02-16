function view(di; n_pa = -1, id = IN)

    if 0 < n_pa

        di = Dict(ke => va for (id, (ke, va)) in enumerate(di) if id <= n_pa)

    end

    JSON.print(di, id)

end
