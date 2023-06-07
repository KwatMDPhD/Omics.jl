module Path

using ..BioLab

function make_absolute(pa)

    rstrip(abspath(expanduser(pa)), '/')

end

function shorten(pa, sh::Int)

    joinpath(splitpath(pa)[clamp(end + sh, 1, end):end]...)

end

function shorten(pa, di; sh = 0)

    sp_ = splitpath(pa)

    ba = basename(di)

    shorten(pa, findlast(sp == ba for sp in sp_) - length(sp_) + sh)

end

function error_extension(pa, ex)

    ex2 = splitext(pa)[2]

    if ex2 != ex

        error()

    end

end

function replace_extension(pa, ex)

    "$(splitext(pa)[1]).$ex"

end

function clean(pa)

    replace(lowercase(pa), r"[^/_.0-9a-z]" => '_')

end

function error_missing(di, re::AbstractString)

    pa = joinpath(di, re)

    if !ispath(pa)

        error()

    end

end

function read(di; join = false, ig_ = (r"^\.",), ke_ = ())

    pa_ = Vector{String}()

    for pa in readdir(di; join)

        ba = basename(pa)

        if !any(contains(ba, ig) for ig in ig_) &&
           (isempty(ke_) || any(contains(ba, ke) for ke in ke_))

            push!(pa_, pa)

        end

    end

    pa_

end

function reset(di)

    rm(di; force = true, recursive = true)

    mkdir(di)

end

function rank(di)

    na_ = readdir(di)

    for (id, na) in enumerate(sort!(na_; by = na -> parse(Float64, rsplit(na, '.'; limit = 3)[1])))

        na2 = "$id.$(join(rsplit(na, '.'; limit=3)[2:end], '.'))"

        if na != na2

            sr = joinpath(di, na)

            de = joinpath(di, na2)

            mv(sr, de)

        end

    end

end

function rename_recursively(di, pa_)

    for (be, af) in pa_

        run(pipeline(`find $di -print0`, `xargs -0 rename --subst-all $be $af`))

    end

end

function sed_recursively(di, pa_)

    for (be, af) in pa_

        run(pipeline(`find $di -type f -print0`, `xargs -0 sed -i "" "s/$be/$af/g"`))

    end

end

end
