function read(pa::String)::Dict

    return JSON.parse(open(pa))

end
