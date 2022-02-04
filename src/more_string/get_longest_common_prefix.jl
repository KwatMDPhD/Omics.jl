function get_longest_common_prefix(st_::Vector{String})::String

    return String(VectorExtension.get_longest_common_prefix([collect(st) for st in st_]))

end
