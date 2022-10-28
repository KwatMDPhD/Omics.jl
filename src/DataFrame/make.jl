function make(va__)

    DataFrames.DataFrame(OnePiece.Matrix.make(va__[2:end]), va__[1])

end

function make(na, ro_, co_, ma)

    insertcols!(DataFrames.DataFrame(ma, co_), 1, na => ro_)

end
