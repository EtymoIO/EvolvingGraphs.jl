module EvolvingGraphs

using Compat

import Base: ==, show, time

export 

# core
Node, Edge, TimeNode, IndexNode, TimeEdge, AbstractEvolvingGraph, 

# graphs
AdjacencyList, build_tree, TimeEdgeList, EvolvingGraph, TimeTensor,
SparseTimeTensor, TimeGraph,

# graph functions
add_node!, add_edge!, add_graph!,
nodes, num_nodes, edges, num_edges,
source, target, matrices, num_matrices, 
timestamps, num_timestamps, reduce_timestamps!,
has_node, out_neighbors, is_directed,
time_graph, evolving_graph, adjacency_tensor, time_tensor, sparse_time_tensor,
matrix, spmatrix,
 
# examples
build_tree, build_evolving_graph, build_evolving_graph2, 
build_sparse_tensor,

# io
egreader,

# algorithms
BFS, DFS

include("common.jl")
 
include("graphs/time_graph.jl") 
include("graphs/adjacency_list.jl")
include("graphs/edge_list.jl")
include("graphs/time_edge_list.jl")
include("graphs/evolving_graph.jl")
include("graphs/tensor.jl")


include("io.jl")
include("show.jl")

include("algorithms/bfs.jl")
include("algorithms/dfs.jl")

# simple test
include("graphs/test_graph.jl")

end # module
