using JSON: parse

function read_json(p::String)::Dict

    return parse(open(p))

end

export read_json
