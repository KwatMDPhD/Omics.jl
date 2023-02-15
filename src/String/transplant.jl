function transplant(st1, st2, de, id_)

    sp1_ = split(st1, de)

    sp2_ = split(st2, de)

    BioLab.Array.error_size(sp1_, sp2_)

    join(((sp1, sp2)[id] for (sp1, sp2, id) in zip(sp1_, sp2_, id_)), de)

end
