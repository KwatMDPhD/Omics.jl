using JSON: parse

function read(pa::String)::Dict

    return parse(open(pa))

end

export read
