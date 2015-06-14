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
add_node!, add_edge!, add_graph!, rm_edge!, has_edge, has_node,
nodes, num_nodes, edges, num_edges,
source, target, matrices, num_matrices, 
timestamps, num_timestamps, reduce_timestamps!,
out_neighbors, is_directed,
time_graph, evolving_graph, weighted_evolving_graph,
attribute_evolving_graph, attributesvec, attributes,
matrix, spmatrix, 
 
# io
egread, egwrite,

# algorithms
katz_centrality, random_time_graph, random_evolving_graph,

# metric
Path, TemporalPath, shortest_temporal_path, shortest_temporal_distance,
shortest_path, shortest_distance, temporal_efficiency, global_temporal_efficiency,

# components
temporal_connected, weak_connected, weak_connected_components,

# sort slice
issorted, sorttime!, sorttime, slice!, slice,

# example
build_evolving_graph

include("common.jl")
include("util.jl")

include("graphs/auxiliary.jl")
include("graphs/time_graph.jl") 
include("graphs/evolving_graph.jl")
include("graphs/weighted_evolving_graph.jl")
include("graphs/attribute_evolving_graph.jl")

include("sort_slice.jl")
include("components.jl")
include("io.jl")
include("show.jl")

include("algorithms/katz_centrality.jl")
include("algorithms/random.jl")

include("metric/shortest_distance.jl")
include("metric/shortest_temporal_distance.jl")
include("metric/temporal_efficiency.jl")

# examples
include("graphs/examples.jl")

end # module
