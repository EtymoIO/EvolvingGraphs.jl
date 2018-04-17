# EvolvingGraphs: working with time-dependent networks in Julia

## Installation

Install Julia v0.6.0 or later, if you haven't already.

```
julia> Pkg.add("EvolvingGraph")
```

## Get Started

We model a time-dependent network, a.k.a an evolving graph, as a ordered sequence of static graphs such that each static graph represents the interaction between nodes at a specific time stamp. The figure below shows an evolving graph with 3 timestamps.

![simple evolving graph](eg.png)

Using `EvolvingGraphs`, we could simply construct this graph by using the function
`add_bunch_of_edges!`, which adds a list of edges all together.

```julia
julia> using EvolvingGraphs

julia> g = EvolvingGraph()
Directed EvolvingGraph 0 nodes, 0 static edges, 0 timestamps

julia> add_bunch_of_edges!(g, [(1,2,1),(1,3,2),(2,3,3)])
Directed EvolvingGraph 3 nodes, 3 static edges, 3 timestamps

julia> edges(g)
3-element Array{EvolvingGraphs.WeightedTimeEdge{EvolvingGraphs.Node{Int64},Int64,Float64},1}:
 Node(1)-1.0->Node(2) at time 1
 Node(1)-1.0->Node(3) at time 2
 Node(2)-1.0->Node(3) at time 3
```

```@contents
Pages = ["examples.md","base.md","graph_types.md","centrality.md", "read_write.md", "algorithms.md"]
Depth = 3
```

## Index

```@index
```
