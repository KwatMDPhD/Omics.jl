module Path

using ..BioLab

function make_absolute(pa)

    return rstrip(abspath(expanduser(pa)), '/')

end

function shorten(pa, n::Int)

    return joinpath(splitpath(pa)[clamp(end - n, 1, end):end]...)

end

function shorten(pa, di; sh = 0)

    sp_ = splitpath(pa)

    na = basename(di)

    n = findlast(sp == na for sp in sp_)

    if isnothing(n)

        error()

    end

    return shorten(pa, length(sp_) - n + sh)

end

function clean(pa)

    cl = replace(lowercase(pa), r"[^/_.0-9a-z]" => '_')

    println("$pa 🧼 $cl")

    return cl

end

function error_extension(pa, ex)

    pae = splitext(pa)[2]

    if pae != ex

        error(pae)

    end

    return nothing

end

function replace_extension(pa, ex)

    return "$(splitext(pa)[1]).$ex"

end

function error_missing(di, pa::AbstractString)

    paj = joinpath(di, pa)

    if !ispath(paj)

        error(paj)

    end

    return nothing

end

function error_missing(di, pa_)

    for pa in pa_

        error_missing(di, pa)

    end

    return nothing

end

function list(di; jo = false, ig_ = (r"^\.",), ke_ = ())

    pa_ = Vector{String}()

    for pa in readdir(di; join = jo)

        na = basename(pa)

        if !any(contains(na, ig) for ig in ig_) &&
           (isempty(ke_) || any(contains(na, ke) for ke in ke_))

            push!(pa_, pa)

        end

    end

    return pa_

end

function make_temporary(pa)

    pat = joinpath(tempdir(), pa)

    if ispath(pat)

        rm(pat; recursive = true)

    end

    return mkdir(pat)

end

function move(paf, pat; ke_ar...)

    spf_ = splitpath(paf)

    spt_ = splitpath(pat)

    n = length(BioLab.Collection.get_common_start((spf_, spt_)))

    println("$(shorten(paf, length(spf_) - n)) 🛷 $(shorten(pat, length(spt_) - n))")

    mv(paf, pat; ke_ar...)

    return nothing

end

function rank(di)

    na_ = readdir(di)

    for (id, na) in enumerate(sort!(na_; by = na -> parse(Float64, rsplit(na, '.'; limit = 3)[1])))

        na2 = "$id.$(join(rsplit(na, '.'; limit=3)[2:end], '.'))"

        if na != na2

            sr = joinpath(di, na)

            de = joinpath(di, na2)

            move(sr, de)

        end

    end

    return nothing

end

function rename_recursively(di, pa_)

    for (be, af) in pa_

        run(pipeline(`find $di -print0`, `xargs -0 rename --subst-all $be $af`))

    end

    return nothing

end

function sed_recursively(di, pa_)

    for (be, af) in pa_

        run(pipeline(`find $di -type f -print0`, `xargs -0 sed -i "" "s/$be/$af/g"`))

    end

    return nothing

end

end
