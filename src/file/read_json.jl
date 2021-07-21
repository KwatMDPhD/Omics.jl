using JSON: parse

function read_json(pa::String)::Dict

    return parse(open(pa))

end

export read_json
