module Animation

using ..Omics

function writ(f1, f2_)

    run(`magick -delay 32 $f2_ $f1`)

    Omics.Path.ope(f1)

end

end
