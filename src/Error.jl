module Error

using ..BioLab

macro is(ex)

    exe = esc(ex)

    quote

        try

            $exe

            false

        catch er

            @info "Errored." er

            true

        end

    end

end

function error_bad(co)

    id_ = findall(BioLab.Bad.is, co)

    if !isempty(id_)

        error(
            "Found $(BioLab.String.count(length(id_), "bad value")).\n$(join(unique(co[id_]), ".\n")).",
        )

    end

end

function error_duplicate(co)

    if isempty(co)

        error("co is empty.")

    end

    if !allunique(co)

        st = BioLab.Collection.count_sort_string(co, 2)

        error("Found $(BioLab.String.count(length(split(st, '\n')), "duplicate")).\n$st")

    end

end

function error_has_key(ke_va, ke)

    if haskey(ke_va, ke)

        error("$ke (=> $(ke_va[ke])) exists.")

    end

end

function error_extension_difference(pa, ex2)

    ex = BioLab.Path.get_extension(pa)

    if ex != ex2

        error("$ex != $ex2.")

    end

end

function error_missing(pa)

    if !ispath(pa)

        error("$pa is missing.")

    end

end

end
