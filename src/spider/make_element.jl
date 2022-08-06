function make_element(ve, cl_)

    Dict("data" => Dict("id" => ve), "classes" => cl_)

end

function make_element(ve::DataType)

    make_element(ve, ["no"])

end

function make_element(ve::String)

    make_element(ve, ["ed", split(ve, ".")[1]])

end

function make_element((so, ta)::Tuple)

    Dict("data" => Dict("source" => so, "target" => ta))

end
