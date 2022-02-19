function sed_recursively(pa, pa_)

    for (be, af) in pa_

        run(pipeline(`find $pa -type f -print0`, `xargs -0 sed -i "" "s/$be/$af/g"`))

    end

end
