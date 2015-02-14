module EvolvingGraphs

import Base: ==, show, print

export 

# common
EvolvingGraph, 

TimeEdge, TimeVertex,

edge_index, source, target, edge_time, vertex_index


include("common.jl")
include("edge_list.jl")
include("tensor.jl")  # generate adjacency tensor 
include("discrete_time_graph.jl")

end # module
