function get_absolute(pa::String)::String

    return abspath(expanduser(pa))

end

export get_absolute
