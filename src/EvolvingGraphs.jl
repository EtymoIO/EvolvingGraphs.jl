module EvolvingGraphs

using Compat

if VERSION < v"0.4-"
    using Docile
end

import Base: ==, show, time, slice, issorted, copy, length

export 

# common
Node, Edge, TimeNode, IndexNode, TimeEdge, WeightedTimeEdge, AttributeTimeEdge,
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
attribute_evolving_graph, attributesvec, attributes,
matrix, spmatrix, 
 
# io
egread,

# algorithms
katz_centrality, random_time_graph, random_evolving_graph,

# metric
Path, TemporalPath, shortest_temporal_path, shortest_temporal_distance,
shortest_path, shortest_distance,

# util
issorted, sorttime!, sorttime, slice!, slice


include("common.jl")
 
include("graphs/time_graph.jl") 
include("graphs/evolving_graph.jl")
include("graphs/weighted_evolving_graph.jl")
include("graphs/attribute_evolving_graph.jl")
include("util.jl")

include("io.jl")
include("show.jl")

include("algorithms/katz_centrality.jl")
include("algorithms/random.jl")

include("metric/shortest_distance.jl")
include("metric/shortest_temporal_distance.jl")

# examples
include("graphs/examples.jl")

end # module
