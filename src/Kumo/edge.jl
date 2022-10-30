function edge()

    ve_id = OnePiece.Vector.pair_index(VE_)

    n_ve = length(ve_id)

    de_x_so_x_ed = fill(0, n_ve, n_ve)

    for (ve1, ve2) in ED_

        de_x_so_x_ed[ve_id[ve2], ve_id[ve1]] = 1

    end

    de_x_so_x_ed

end
