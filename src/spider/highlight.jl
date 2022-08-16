function highlight(ve_x_ve_x_nu)

    ve_x_ve_x_st = fill("", size(ve_x_ve_x_nu))

    for ro in 1:size(ve_x_ve_x_nu, 1), co in 1:size(ve_x_ve_x_nu, 1)

        nu = ve_x_ve_x_nu[ro, co]

        if nu != 0

            ve_x_ve_x_st[ro, co] = "$nu"

        end

    end

    co_ = string.(VERTEX_)

    insertcols!(DataFrame(ve_x_ve_x_st, co_), 1, "Vertex" => co_)

end
