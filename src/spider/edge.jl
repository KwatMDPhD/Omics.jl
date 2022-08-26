function edge()

    ve_id = Dict(ve => id for (id, ve) in enumerate(VERTEX_))

    n_ve = length(ve_id)

    de_x_so_x_ed = fill(0, n_ve, n_ve)

    for (ve1, ve2) in EDGE_

        de_x_so_x_ed[ve_id[ve2], ve_id[ve1]] = 1

    end

    de_x_so_x_ed

end
