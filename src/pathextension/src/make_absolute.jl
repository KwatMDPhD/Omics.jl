function make_absolute(pa::String)::String

    return string(rstrip(abspath(expanduser(pa)), '/'))

end
