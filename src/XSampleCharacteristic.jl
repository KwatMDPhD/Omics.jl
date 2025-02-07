module XSampleCharacteristic

function lo(he::AbstractString, va_)

    bo = join(
        "$uu $un.\n" for
        (uu, un) in sort!(map(un -> (count(==(un), va_), un), unique(va_)))
    )

    @info "$he\n$bo"

end

function lo(ch_, va___)

    for id in sortperm(va___; by = an_ -> lastindex(unique(an_)))

        lo("🔦 ($id) $(ch_[id])", va___[id])

    end

end

end
