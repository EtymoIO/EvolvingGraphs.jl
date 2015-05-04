module EvolvingGraphs

using Compat

import Base: ==, show, time

export 

# common
Node, Edge, TimeNode, IndexNode, TimeEdge, AbstractEvolvingGraph, 
key, make_node, index, time, rev,

# graphs
TimeGraph, EvolvingGraph,

# graph functions
add_node!, add_edge!, add_graph!,
nodes, num_nodes, edges, num_edges,
source, target, matrices, num_matrices, 
timestamps, num_timestamps, reduce_timestamps!,
has_node, out_neighbors, is_directed,
time_graph, evolving_graph, 
matrix, spmatrix, 
random_time_graph,
 
# examples
build_tree, build_evolving_graph, build_evolving_graph2, 

# io
egreader,

# algorithm
katz_centrality

include("common.jl")
 
include("graphs/time_graph.jl") 
include("graphs/evolving_graph.jl")

include("io.jl")
include("show.jl")

include("algorithms/katz_centrality.jl")
include("algorithms/random.jl")

# examples
include("graphs/examples.jl")

end # module
