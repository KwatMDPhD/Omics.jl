function make_absolute(pa)

    return string(rstrip(abspath(expanduser(pa)), '/'))

end
