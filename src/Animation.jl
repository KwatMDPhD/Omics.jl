module Animation

using ..Omics

function writ(gi, pn_)

    run(`magick -delay 32 $pn_ $gi`)

    Omics.Path.ope(gi)

end

end
