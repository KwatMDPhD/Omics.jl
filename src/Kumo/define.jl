macro ab(sy)

    :(abstract type $sy end)

end

macro st(sy, su)

    :(struct $sy <: $su end)

end

macro st(sy)

    :(struct $sy end)

end
