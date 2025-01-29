module Graphs

using Graphs: AbstractGraph, SimpleDiGraph, add_edge!, add_vertex!, nv

using ..PGMs

struct Graph

    gr::AbstractGraph

    no_::Vector{DataType}

    no_id::Dict{DataType, UInt16}

    function Graph()

        return new(SimpleDiGraph(), DataType[], Dict{DataType, UInt16}())

    end

end

function add_node!(gr, no)

    if haskey(gr.no_id, no)

        error("$no exists.")

    end

    add_vertex!(gr.gr)

    push!(gr.no_, no)

    return gr.no_id[no] = nv(gr.gr)

end

function graph(mo)

    gr = Graph()

    for na in names(mo; all = true)

        fi = getfield(mo, na)

        if fi isa DataType && fi <: PGMs.Nodes.Node

            add_node!(gr, fi)

        end

    end

    for me in methods(PGMs.Factors.p!)

        pa_ = me.sig.parameters

        if isone(lastindex(pa_))

            continue

        end

        pa_ = pa_[2:end]

        if any(pa -> !haskey(gr.no_id, pa), pa_)

            continue

        end

        ic = gr.no_id[pa_[1]]

        for pa in pa_[2:end]

            add_edge!(gr.gr, gr.no_id[pa] => ic)

        end

    end

    return gr

end

end
