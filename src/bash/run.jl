using Base: AbstractCmd, AbstractPipe, run as base_run

function run(co::AbstractCmd)::AbstractPipe

    println(co)

    return base_run(co)

end

export run
