module EvolvingGraphs

import Base: ==, show

export 

# core
Node, Edge, TimeNode, TimeEdge, AbstractEvolvingGraph, 

# graphs
AdjacencyList, build_tree, 

# algorithms
BFS, DFS

include("core.jl")

  
include("graphs/adjacency_list.jl")
include("graphs/edge_list.jl")
include("graphs/tensor.jl")

include("algorithms/bfs.jl")
include("algorithms/dfs.jl")

# simple test
include("graphs/test_graph.jl")

end # module
