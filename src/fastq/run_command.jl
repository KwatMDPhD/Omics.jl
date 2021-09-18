function run_command(co::Base.AbstractCmd)

    println(co)

    run(co)

end

export run_command
