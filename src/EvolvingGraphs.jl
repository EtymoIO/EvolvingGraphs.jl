module EvolvingGraphs

import Base: ==, show,  issorted, deepcopy, length, eltype
using Requires


export

   # base
   Node, Edge, TimeNode, AttributeNode, TimeEdge, WeightedTimeEdge,
   make_node, node_index, node_key, edge_reverse, node_timestamp, edge_timestamp,
   node_attributes, edge_weight,

   # graph types
   AbstractGraph, AbstractEvolvingGraph, AbstractStaticGraph,
   TimeGraph, AggregatedGraph, EvolvingGraph,
   IntEvolvingGraph, IntTimeEdge, DiGraph,

   # graph functions
   ## modify graph
   add_node!, add_edge!, add_graph!, rm_edge!, add_graph!, undirected!,
   ## retrive information
   has_edge, has_node, in_edges, in_degree, out_edges, out_degree,
   nodes, num_nodes, edges, num_edges,
   source, target, matrices, num_matrices,
   timestamps, num_timestamps, activenodes,
   forward_neighbors, is_directed, undirected,
   time_graph, evolving_graph, weighted_evolving_graph,
   attribute_evolving_graph, attributesvec, attributes,
   matrix, spmatrix, attributes_values, aggregated_graph,
   int_evolving_graph, temporal_nodes,
   digraph,

   # io
   egread, egwrite,

   # algorithms
   random_time_graph, random_evolving_graph, breadth_first_visit,

   # metric
   Path, TemporalPath, shortest_temporal_path, shortest_temporal_distance,
   shortest_path, shortest_distance, temporal_efficiency, global_temporal_efficiency,

   # components
   temporal_connected, weak_connected, weak_connected_components,

   # sort slice
   issorted, sorttime!, sorttime, slice!, slice


include("base.jl")

# graph IO
include("read_write/evolving_graph_io.jl")
# need to import EzXML
@require EzXML include("read_write/graphml.jl")
# graph types
## static graphs
include("graph_types/digraph.jl")
include("graph_types/time_graph.jl")
include("graph_types/aggregated_graph.jl")
## evolving graphs
include("graph_types/evolving_graph.jl")
include("graph_types/int_evolving_graph.jl")
include("graph_types/matrix_list.jl")
include("graph_types/incidence_matrix.jl")

include("show.jl")

# algorithms
include("algorithms/bfs.jl")
include("algorithms/sort_slice.jl")
include("algorithms/components.jl")
include("algorithms/random.jl")

# metric
include("algorithms/shortest_distance.jl")
include("algorithms/shortest_temporal_distance.jl")

# Centrality module
include("centrality/centrality.jl")

end # module
