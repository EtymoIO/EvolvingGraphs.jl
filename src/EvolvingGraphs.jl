module EvolvingGraphs

using Compat

if VERSION < v"0.4-"
    using Docile
end

import Base: ==, show, time

export 

# common
Node, Edge, TimeNode, IndexNode, TimeEdge, WeightedTimeEdge, ExTimeEdge,
AbstractEvolvingGraph, key, make_node, index, rev, AttributeDict,

# graph types
TimeGraph, EvolvingGraph, WeightedEvolvingGraph, AttributeEvolvingGraph,

# graph functions
add_node!, add_edge!, add_graph!,
nodes, num_nodes, edges, num_edges,
source, target, matrices, num_matrices, 
timestamps, num_timestamps, reduce_timestamps!,
has_node, out_neighbors, is_directed,
time_graph, evolving_graph, weighted_evolving_graph,
matrix, spmatrix, 
random_time_graph, random_evolving_graph,
 
# examples
build_evolving_graph, build_evolving_graph2, 

# io
egreader,

# algorithms
katz_centrality

include("common.jl")
 
include("graphs/time_graph.jl") 
include("graphs/evolving_graph.jl")
include("graphs/weighted_evolving_graph.jl")
include("graphs/attribute_evolving_graph.jl")

include("io.jl")
include("show.jl")

include("algorithms/katz_centrality.jl")
include("algorithms/random.jl")

# examples
include("graphs/examples.jl")

end # module
