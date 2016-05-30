module EvolvingGraphs

import Base: ==, show,  slice, issorted, deepcopy, length, eltype

export 

  # base
  Node, Edge, TimeNode, AttributeNode, TimeEdge, WeightedTimeEdge,
  AttributeTimeEdge, key, make_node, node_index, rev, AttributeDict,
  timestamp,

   # graph types
   AbstractGraph, AbstractEvolvingGraph, AbstractStaticGraph,
   TimeGraph, AggregatedGraph, EvolvingGraph, 
   WeightedEvolvingGraph, AttributeEvolvingGraph, 
   IntEvolvingGraph, IntTimeEdge,

   # graph functions
   add_node!, add_edge!, add_graph!, rm_edge!, has_edge, has_node,
   nodes, num_nodes, edges, num_edges,
   source, target, matrices, num_matrices, 
   timestamps, num_timestamps, activenodes,
   forward_neighbors, is_directed, undirected!, undirected, 
   time_graph, evolving_graph, weighted_evolving_graph, weight,
   attribute_evolving_graph, attributesvec, attributes,
   matrix, spmatrix, attributes_values, aggregated_graph,
 
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
   issorted, sorttime!, sorttime, slice!, slice


include("base.jl")
include("io.jl")

# graph types
include("graphs/time_graph.jl") 
include("graphs/aggregated_graph.jl")
include("graphs/evolving_graph.jl")
include("graphs/weighted_evolving_graph.jl")
include("graphs/attribute_evolving_graph.jl")
include("graphs/int_evolving_graph.jl")
include("graphs/matrix_list.jl")
include("graphs/incidence_matrix.jl")

include("show.jl")

# algorithms
include("algorithms/bfs.jl")
include("algorithms/sort_slice.jl")
include("algorithms/components.jl")
include("algorithms/katz_centrality.jl")
include("algorithms/random.jl")

# metric
include("algorithms/shortest_distance.jl")
include("algorithms/shortest_temporal_distance.jl")
include("algorithms/temporal_efficiency.jl")


end # module
