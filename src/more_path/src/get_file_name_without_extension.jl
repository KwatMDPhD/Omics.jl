function get_file_name_without_extension(pa::String)::String

    return splitext(splitdir(pa)[2])[1]

end
