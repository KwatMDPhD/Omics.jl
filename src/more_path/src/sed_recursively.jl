function sed_recursively(pa::String, re_::Vector{Pair{String,String}})::Nothing

    for (be, af) in re_

        run(pipeline(`find $pa -type f -print0`, `xargs -0 -t sed -i "" "s/$be/$af/g"`))

    end

    return nothing

end
