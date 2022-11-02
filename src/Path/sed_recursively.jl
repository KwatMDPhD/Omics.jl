function sed_recursively(di, pa_)

    for (be, af) in pa_

        run(pipeline(`find $di -type f -print0`, `xargs -0 sed -i "" "s/$be/$af/g"`))

    end

end
