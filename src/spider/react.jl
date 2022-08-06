function >>(ve1, ve2)

    add(ve1, ve2)

    ve2

end

function >>(ve1_::Vector, ve2)

    for ve1 in ve1_

        add(ve1, ve2)

    end

    ve2

end

function >>(ve1, ve2_::Vector)

    for ve2 in ve2_

        add(ve1, ve2)

    end

    ve2_

end

function make_vertex2(ve1::DataType)

    "act.$ve1"

end

function make_vertex2(ve1_::Vector{DataType})

    "react.$(join(ve1_, "_"))"

end

function >>(ve1::Union{DataType, Vector{DataType}}, ve3::Union{DataType, Vector{DataType}})

    ve1 >> make_vertex2(ve1) >> ve3

end
