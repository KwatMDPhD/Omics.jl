function rename_recursively(ro, pa_)

    for (be, af) in pa_

        run(pipeline(`find $ro -print0`, `xargs -0 rename --subst-all $be $af`))

    end

end
