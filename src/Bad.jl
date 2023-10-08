module Bad

function is(::Any)

    false

end

function is(::Nothing)

    true

end

function is(::Missing)

    true

end

function is(fl::AbstractFloat)

    !isfinite(fl)

end

function is(st::AbstractString)

    isempty(st) || contains(st, r"^[^0-9A-Za-z]+$")

end

end
