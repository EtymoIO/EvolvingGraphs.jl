module EvolvingGraphs

import Base: ==, show

export 

# core
Node, Edge, TimeNode, IndexNode, TimeEdge, AbstractEvolvingGraph, 

# graphs
AdjacencyList, build_tree, TimeEdgeList, 

# graph functions
add_node!, add_edge!, build_tree, adjacency_tensor, build_evolving_graph,

# algorithms
BFS, DFS

include("core.jl")

  
include("graphs/adjacency_list.jl")
include("graphs/edge_list.jl")
include("graphs/time_edge_list.jl")
include("graphs/tensor.jl")

include("algorithms/bfs.jl")
include("algorithms/dfs.jl")

# simple test
include("graphs/test_graph.jl")

end # module
