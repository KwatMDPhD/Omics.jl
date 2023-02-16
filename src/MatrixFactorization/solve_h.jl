function solve_h(ro_x_co_x_po, ro_x_fa_x_po)

    return pinv(ro_x_fa_x_po) * ro_x_co_x_po

end
