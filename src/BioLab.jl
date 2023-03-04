module BioLab

macro include()

    di, fi = splitdir(string(__source__.file))

    return esc(quote

        for na in readdir($di)

            if (na != $fi) && endswith(na, ".jl")

                include(na)

            end

        end

    end)

end

@include

const RA = 20121020

const CA_ = ['A', '2', '3', '4', '5', '6', '7', '8', '9', 'X', 'J', 'Q', 'K']

const TE = BioLab.Path.make_temporary("BioLab")

function __init__()

    ENV["LINES"] = 40

    ENV["COLUMNS"] = 80

    BioLab.Path.empty(TE)

    return nothing

end

function check_print(pr, ar...)

    if pr

        println(ar...)

    end

    return nothing

end

function print_header()

    println("❀"^99)

    return nothing

end

function print_header(st)

    println("●"^99)

    println(st)

    println("◦"^99)

    return nothing

end

macro check_error(ex)

    return quote

        try

            $(esc(ex))

            false

        catch er

            println("🎣")

            display(er)

            true

        end

    end

end

end
