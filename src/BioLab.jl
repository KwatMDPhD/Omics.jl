module BioLab

for na in readdir(@__DIR__)

    if !startswith(na, '_') && na != "BioLab.jl"

        include(na)

    end

end

function __init__()

    BioLab.Path.reset(Constant.TE)

end

function print_header(st)

    println('●'^99)

    println(st)

    println('◦'^99)

end

function print_header()

    println('❀'^99)

end

function check_print(pr, ar...)

    if pr

        println(ar...)

    end

end


macro is_error(ex, pr = true)

    quote

        try

            $(esc(ex))

            false

        catch er

            check_print($pr, er)

            true

        end

    end

end

end
