module Bad

function is(::Nothing)

    true

end

function is(::Missing)

    true

end

function is(fl::Float64)

    !isfinite(fl) || isequal(fl, -0.0)

end

function is(st::AbstractString)

    contains(st, r"^\s*$")

end

function is(::Any)

    false

end

end
