module Path

using ..Nucleus

macro here()

    na = basename(string(__source__.file))

    if endswith(na, ".jl")

        na = na[1:(end - 3)]

    end

    na

end

function clean(pa)

    if contains(pa, '/')

        di, na = splitdir(pa)

        joinpath(di, Nucleus.String.clean(lowercase(na)))

    else

        Nucleus.String.clean(lowercase(pa))

    end

end

function wait(pa, ma = 4; sl = 1)

    su = 0

    while su < ma && !ispath(pa)

        sleep(sl)

        @info "Waiting for $pa ($(su += sl) / $ma)"

    end

end

function read(di, se = ""; ke_ar...)

    filter!(pa -> contains(basename(pa), se), readdir(di; ke_ar...))

end

function open(pa)

    try

        run(`open --background $pa`)

        nothing

    catch

        @warn "Could not open $pa."

    end

end

function establish(di)

    di = clean(di)

    if !isdir(di)

        mkdir(di)

    end

    di

end

end
