function edge()

    ve_id = BioLab.Vector.pair_index(VE_)[1]

    n = length(ve_id)

    so_x_de_x_ed = fill(0, (n, n))

    for (so, de) in ED_

        so_x_de_x_ed[ve_id[so], ve_id[de]] = 1

    end

    so_x_de_x_ed

end
