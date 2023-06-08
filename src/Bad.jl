module Bad

function is_bad(::Nothing)

    true

end

function is_bad(::Missing)

    true

end

function is_bad(fl::Float64)

    !isfinite(fl) || isequal(fl, -0.0)

end

function is_bad(st::AbstractString)

    contains(st, r"^\s*$")

end

function is_bad(::Any)

    false

end

end
