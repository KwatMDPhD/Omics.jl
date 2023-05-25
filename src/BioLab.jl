module BioLab

for na in readdir(@__DIR__)

    if na != "BioLab.jl"

        include(na)

    end

end

function __init__()

    BioLab.Path.empty(Constant.TE)

end

function check_println(pr, ar...)

    if pr

        println(ar...)

    end

end

function print_header()

    println('❀'^99)

end

function print_header(st)

    println('●'^99)

    println(st)

    println('◦'^99)

end

macro is_error(ex)

    quote

        try

            $(esc(ex))

            false

        catch er

            println(er)

            true

        end

    end

end

end
