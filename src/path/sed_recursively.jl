function sed_recursively(ro, pa_)

    for (be, af) in pa_

        run(pipeline(`find $ro -type f -print0`, `xargs -0 sed -i "" "s/$be/$af/g"`))

    end

end
