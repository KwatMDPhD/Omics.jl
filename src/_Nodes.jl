module Nodes

import Base: show

abstract type Node end

function get_values() end

function set_index!(no, id)

    if !(0 <= id <= lastindex(get_values(no)))

        throw(DomainError(id))

    end

    return no.index = id

end

macro node(no, va_)

    quote

        mutable struct $no <: Node

            index::UInt16

            function $no()

                return new(0)

            end

            function $no(id)

                no = new()

                set_index!(no, id)

                return no

            end

        end

        function $(esc(:(PGMs.Nodes.get_values)))(::$(esc(no)))

            return $(esc(va_))

        end

    end

end

function show(io::IO, no::Node)

    ty = rsplit(string(typeof(no)), '.'; limit = 2)[end]

    va_ = get_values(no)

    id = no.index

    return print(io, iszero(id) ? "$ty = $va_" : "$ty = $va_[$id] = $(va_[id])")

end

end
