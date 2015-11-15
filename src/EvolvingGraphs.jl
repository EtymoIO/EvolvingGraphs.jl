module EvolvingGraphs

using Compat
using Requires # for plotting features

if VERSION < v"0.4-"
    using Docile
end

import Base: ==, show,  slice, issorted, copy, length, eltype

export 

# core
AbstractGraph, AbstractEvolvingGraph, AbstractStaticGraph,
Node, Edge, TimeNode, AttributeNode, TimeEdge, WeightedTimeEdge, AttributeTimeEdge,
key, make_node, index, rev, AttributeDict, timestamp,


# graph types
TimeGraph, AggregatedGraph, EvolvingGraph, WeightedEvolvingGraph, 
AttributeEvolvingGraph, IntEvolvingGraph, IntTuple2, IntTimeEdge, 
MatrixList,

# graph functions
add_node!, add_edge!, add_graph!, rm_edge!, has_edge, has_node,
nodes, num_nodes, edges, num_edges,
source, target, matrices, num_matrices, 
timestamps, num_timestamps, reduce_timestamps!,
out_neighbors, is_directed, undirected!, undirected, 
time_graph, evolving_graph, weighted_evolving_graph, weight,
attribute_evolving_graph, attributesvec, attributes,
matrix, spmatrix, attributes_values, aggregated_graph, 
matrix_list,
 
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

# plotting
layout_spring, draw_layout,

# example
build_evolving_graph

include("core.jl")

include("graphs/generic_graph_functions.jl")
include("graphs/time_graph.jl") 
include("graphs/aggregated_graph.jl")
include("graphs/evolving_graph.jl")
include("graphs/weighted_evolving_graph.jl")
include("graphs/attribute_evolving_graph.jl")
include("graphs/int_evolving_graph.jl")
include("graphs/matrix_list.jl")

include("io.jl")
include("show.jl")

include("algorithms/bfs.jl")
include("algorithms/sort_slice.jl")
include("algorithms/components.jl")
include("algorithms/katz_centrality.jl")
include("algorithms/random.jl")

# metric
include("algorithms/shortest_distance.jl")
include("algorithms/shortest_temporal_distance.jl")
include("algorithms/temporal_efficiency.jl")

@require Compose begin
    layoutfiles(fname::AbstractString) = 
         joinpath(dirname(@__FILE__), "plot", "layout", fname)
    include(layoutfiles("random.jl"))
    include(layoutfiles("spring.jl"))
    include(layoutfiles("circular.jl"))
    @require Colors include(joinpath(dirname(@__FILE__),"plot","draw.jl"))
end

# examples
include("examples.jl")

end # module
