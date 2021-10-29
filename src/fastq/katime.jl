using Dates: now, CompoundPeriod

function katime(ca)

    println("-"^80)

    st = now()

    println("Starting ", ca, " at " st)

    ca 

    en = now()

    println("Ended at ", en)

    println("Took ", canonicalize(Dates.CompoundPeriod(en - st)))

    println()

end
