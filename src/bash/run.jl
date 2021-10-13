function run(co::Base.AbstractCmd)::Base.AbstractPipe

    println(co)

    return Base.run(co)

end

export run
