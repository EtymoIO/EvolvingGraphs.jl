# root type

abstract EvolvingGraph{V, E, T}


##########################################
#
#  edge types
#
##########################################


immutable TimeEdge{T}
    source::T
    target::T
    time::Real
    function TimeEdge(source::T, target::T, time::Real = 0)
        time >= 0 || error("time must be non-negative")
        new(source, target, time)
    end
end

source(e::TimeEdge) = e.source
target(e::TimeEdge) = e.target
edge_time(e::TimeEdge) = e.time
source{V}(e::TimeEdge{V}, g::TimeEdge{V}) = e.source
target{V}(e::TimeEdge{V}, g::TimeEdge{V}) = e.target

function show(io::IO, e::TimeEdge)
    print(io, "edge $(e.source) -> $(e.target) at time $(e.time)")
end


##############################################
#
# vertex types
#
##############################################


immutable TimeVertex{T}
    index::Int
    key::T
    time::Real

    function TimeVertex(index::Int, key::T, time::Real = 0)
        time >= 0 || error("time must be non-negative.")

        new(index, key, time)
    end
end

vertex_key(v::TimeVertex) = v.key
vertex_index(v::TimeVertex) = v.index
vertex_time(v::TimeVertex) = v.time





