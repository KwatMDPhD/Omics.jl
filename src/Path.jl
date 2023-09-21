module Path

function clean(na)

    if contains(na, '/')

        error("\"$na\" contains '/'.")

    end

    replace(lowercase(na), r"[^.0-9_a-z]" => '_')

end

function get_extension(pa)

    chop(splitext(pa)[2]; head = 1, tail = 0)

end

function wait(pa, ma = 4; sl = 1)

    se = 0

    while se < ma && !ispath(pa)

        sleep(sl)

        @info "Waiting for $pa ($(se += sl) / $ma)"

    end

end

function read(di; ig_ = (), ke_ = (), ke_ar...)

    pa_ = Vector{String}()

    for pa in readdir(di; ke_ar...)

        na = basename(pa)

        if !any(occursin(na), ig_) && (isempty(ke_) || any(occursin(na), ke_))

            push!(pa_, pa)

        end

    end

    pa_

end

function open(pa)

    try

        run(`open --background $pa`)

    catch

        @warn "Could not open $pa."

    end

end

function remove(pa; ke_ar...)

    @info "Removing $pa"

    rm(pa; ke_ar...)

end

function remake_directory(di)

    if isdir(di)

        remove(di; recursive = true)

    elseif ispath(di)

        error("$di is not a directory.")

    end

    mkdir(di)

end

# TODO: Consider using '.' only before an extension.
function rank(di)

    flnaex_ = rsplit.(read(di), '.'; limit = 3)

    for (id, (fl, pr, ex)) in enumerate(sort!(flnaex_; by = flnaex -> parse(Float64, flnaex[1])))

        na1 = "$fl.$pr.$ex"

        na2 = "$id.$pr.$ex"

        if na1 != na2

            mv(joinpath(di, na1), joinpath(di, na2))

        end

    end

    di

end

end
