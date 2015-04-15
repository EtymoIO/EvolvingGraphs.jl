module EvolvingGraphs

using Compat

import Base: ==, show

export 

# core
Node, Edge, TimeNode, IndexNode, TimeEdge, AbstractEvolvingGraph, 

# graphs
AdjacencyList, build_tree, TimeEdgeList, EvolvingGraph, TimeTensor,

# graph functions
add_node!, add_edge!, build_tree, adjacency_tensor, build_evolving_graph,
evolving_graph, nodes, num_nodes, edges, num_edges, build_evolving_graph2,
source, target, edge_time, time_tensor, matrices, num_matrices, 

# algorithms
BFS, DFS

include("common.jl")
  
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
