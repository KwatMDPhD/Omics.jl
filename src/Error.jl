module Error

using ..Nucleus

macro is(ex)

    quote

        try

            $(esc(ex))

            false

        catch er

            @info "Caught an error: $(er.msg)"

            true

        end

    end

end

function error_0(n)

    if iszero(n)

        error("0.")

    end

end

function error_empty(an_)

    if isempty(an_)

        error("`$an_` is empty.")

    end

end

function error_duplicate(an_)

    if !allunique(an_)

        st = Nucleus.Collection.count_sort_string(an_, 2)

        error("Found $(Nucleus.String.count(count('\n', st), "duplicate")).\n$st")

    end

end

function error_bad(fu, an_)

    id_ = findall(fu, an_)

    if !isempty(id_)

        de = ".\n"

        error(
            "Found $(Nucleus.String.count(lastindex(id_), "bad value"))$de$(join(unique(an_[id_]), de))$de",
        )

    end

end

function error_length_difference(an___)

    if !isone(lastindex(unique(lastindex.(an___))))

        error("Lengths differ.")

    end

end

function error_has_key(ke_va, ke)

    if haskey(ke_va, ke)

        error("`$ke` => `$(ke_va[ke])`.")

    end

end

function error_extension_difference(pa, ex)

    pae = Nucleus.Path.get_extension(pa)

    if pae != ex

        error("`$pae` != `$ex`.")

    end

end

function error_missing(pa)

    if !ispath(pa)

        error("Missing $pa.")

    end

end

end
