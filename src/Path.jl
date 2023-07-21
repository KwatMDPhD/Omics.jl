module Path

function error_missing(pa)

    if !ispath(pa)

        error("$pa is missing.")

    end

end

function error_extension_difference(pa, ex2)

    ex = chop(splitext(pa)[2]; head = 1, tail = 0)

    if ex != ex2

        error("Extensions differ. $ex != $ex2.")

    end

end

function clean(pa)

    replace(lowercase(pa), r"[^/_.0-9a-z]" => '_')

end

function wait(pa; sl = 1, li = 8)

    se = 0

    while se <= li && !ispath(pa)

        sleep(sl)

        se += sl

        @info "Waiting for $pa ($se/$li)"

    end

end

function open(pa)

    try

        run(`open --background $pa`)

    catch

        @error "Could not open $pa."

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

function make_directory(di)

    if isdir(di)

        @error "$di already exists."

    else

        mkdir(di)

    end

    di

end

function rank(di)

    flnaex_ = rsplit.(readdir(di), '.'; limit = 3)

    for (id, (fl, pr, ex)) in enumerate(sort!(flnaex_; by = flnaex -> parse(Float64, flnaex[1])))

        na1 = "$fl.$pr.$ex"

        na2 = "$id.$pr.$ex"

        if na1 != na2

            mv(joinpath(di, na1), joinpath(di, na2))

        end

    end

end

end
