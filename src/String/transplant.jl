function transplant(sth, std, de, id_)

    sph_ = split(sth, de)

    spd_ = split(std, de)

    OnePiece.Array.error_size((sph_, spd_))

    join(((sph, spd)[id] for (sph, spd, id) in zip(sph_, spd_, id_)), de)

end
