module Factors

using MacroTools: combinedef, splitdef

function p!() end

macro factor(fu)

    sp = splitdef(fu)

    if sp[:name] != :p!

        error("the function name is not `p!`.")

    end

    if !issorted(sp[:args][2:end]; by = ar -> ar.args[2])

        error("the second to last arguments are not sorted by their types.")

    end

    sp[:name] = :(PGMs.Factors.p!)

    quote

        $(esc(combinedef(sp)))

    end

end

end
