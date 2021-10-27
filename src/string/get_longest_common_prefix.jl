using ..vector: get_longest_common_prefix as vector_get_longest_common_prefix

function get_longest_common_prefix(st_::Vector{String})::String

    return String(vector_get_longest_common_prefix([collect(st) for st in st_]))

end

export get_longest_common_prefix
