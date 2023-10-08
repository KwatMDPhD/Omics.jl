module Error

using ..BioLab

macro is(ex)

    quote

        try

            $(esc(ex))

            false

        catch er

            @error "Errored." er

            true

        end

    end

end

function error_empty(an_)

    if isempty(an_)

        error("`$an_` is empty.")

    end

end

function error_bad(an_)

    id_ = findall(BioLab.Bad.is, an_)

    if !isempty(id_)

        # TODO: Benchmark.
        error(
            "Found $(BioLab.String.count(length(id_), "bad value")).\n$(join(unique(an_[id_]), ".\n")).",
        )

    end

end

function error_duplicate(an_)

    if !allunique(an_)

        st = BioLab.Collection.count_sort_string(an_, 2)

        error("Found $(BioLab.String.count(count('\n', st) + 1, "duplicate")).\n$st")

    end

end

# TODO: Test.
function error_length_difference(an___)

    if !isone(length(unique(length.(an___))))

        error("Lengths differ.")

    end

end

function error_has_key(ke_va, ke)

    if haskey(ke_va, ke)

        error("`$ke` => `$(ke_va[ke])`.")

    end

end

function error_extension_difference(pa, ex)

    pae = BioLab.Path.get_extension(pa)

    if pae != ex

        error("`$pae` != `$ex`.")

    end

end

function error_missing(pa)

    if !ispath(pa)

        error("$pa is missing.")

    end

end

end
