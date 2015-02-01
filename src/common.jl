# root type

abstract EvolvingGraph{V, E, T}


##########################################
#
#  edge types
#
##########################################


immutable EvolvingEdge{T}
    index::Nullable{Int}
    source::Nullable{T}
    target::Nullable{T}
    time::Real
end

edge_index(e::EvolvingEdge) = e.index
source(e::EvolvingEdge) = e.source
target(e::EvolvingEdge) = e.target
edge_time(e::EvolvingEdge) = e.time
source{V}(e::EvolvingEdge{V}, g::EvolvingEdge{V}) = e.source
target{V}(e::EvolvingEdge{V}, g::EvolvingEdge{V}) = e.target




##############################################
#
# vertex types
#
##############################################


immutable EvolvingVertex{T}
    index::Nullable{Int}
    key::Nullable{T}
    time::Real
end

vertex_index(v::EvolvingVertex) = v.index
vertex_time(v::EvolvingVertex) = v.time





