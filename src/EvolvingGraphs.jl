module EvolvingGraphs

import Base: ==

export 

# common
EvolvingGraph, 

TimeEdge, TimeKeyVertex,

edge_index, source, target, edge_time, vertex_index






include("common.jl")
include("tensor.jl")  # generate adjacency tensor 


end # module
