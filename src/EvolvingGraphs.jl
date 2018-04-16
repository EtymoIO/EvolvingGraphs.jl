module EvolvingGraphs

import Base: ==, show, issorted, deepcopy, length, eltype, push!, append!
using Requires


export

   # base
   Node, Edge, TimeNode, AttributeNode, TimeEdge, WeightedTimeEdge,
   make_node, node_index, node_key, edge_reverse, node_timestamp, edge_timestamp, find_node,
   node_attributes, edge_weight,
   AbstractPath, TemporalPath,

   # graph types
   AbstractGraph, AbstractEvolvingGraph, AbstractStaticGraph,
   EvolvingGraph, DiGraph, IntAdjacencyList, MatrixList,

   evolving_graph_from_arrays, add_bunch_of_edges!,
   adjacency_matrix, sparse_adjacency_matrix,
   evolving_graph_to_adj, evolving_graph_to_matrices,

   # graph functions
   ## modify graph
   add_node!, add_edge!, add_graph!, rm_edge!, add_graph!, undirected!,

   has_edge, has_node, in_edges, in_degree, out_edges, out_degree, has_active_node,
   nodes, num_nodes, edges, num_edges,
   source, target, matrices, num_matrices, unique_timestamps,
   timestamps, num_timestamps, active_nodes, num_active_nodes,
   forward_neighbors, backward_neighbors, is_directed, undirected, attributes_values, aggregate_graph,
   random_graph, random_evolving_graph,

   # io
   egread, egwrite,

   # algorithms
   random_time_graph, random_evolving_graph, breadth_first_visit,

   # metric
   breadth_first_impl, depth_first_impl,
   shortest_temporal_path, shortest_temporal_distance,
   shortest_path, shortest_distance, temporal_efficiency, global_temporal_efficiency,

   # components
   temporal_connected, weak_connected, weak_connected_components,

   # sort slice
   issorted, sort_timestamps!, sort_timestamps, slice_timestamps!, slice_timestamps

include("base.jl")

# graph IO
include("read_write/evolving_graph_io.jl")
# need to import EzXML
@require EzXML include("read_write/graphml.jl")

# graph types
## static graphs
include("graph_types/static_dgraph.jl")

## evolving graphs
include("graph_types/evolving_graph.jl")


# Other types
include("graph_types/matrix_list.jl")
include("graph_types/adjacency_list.jl")
include("graph_types/incidence_list.jl")

include("show.jl")

# algorithms
include("algorithms/bfs.jl")
include("algorithms/dfs.jl")
include("algorithms/sort_slice.jl")
include("algorithms/components.jl")
include("algorithms/random.jl")

# metric
include("algorithms/shortest_distance.jl")
include("algorithms/shortest_temporal_distance.jl")

# Centrality module
include("centrality/centrality.jl")

end # module
