
"""
    issorted(g)

Return `true` if the timestamps of an evolving graph `g` is sorted and `false` otherwise.
"""
function issorted(g::EvolvingGraph)
    return issorted(g.timestamps)
end

"""
    sort_timestamps!(g)

Sort an evolving graph `g` according to the order of its timestamps.

```jldoctest
julia> using EvolvingGraphs

julia> g = EvolvingGraph()
Directed EvolvingGraph 0 nodes, 0 static edges, 0 timestamps

julia> add_bunch_of_edges!(g, [(1,2,2001),(3,4,2008),(5,6,2007),(2,1,2003)])
Directed EvolvingGraph 6 nodes, 4 static edges, 4 timestamps

julia> edges(g)
4-element Array{EvolvingGraphs.WeightedTimeEdge{EvolvingGraphs.Node{Int64},Int64,Float64},1}:
 Node(1)-1.0->Node(2) at time 2001
 Node(3)-1.0->Node(4) at time 2008
 Node(5)-1.0->Node(6) at time 2007
 Node(2)-1.0->Node(1) at time 2003

julia> sort_timestamps!(g)
Directed EvolvingGraph 6 nodes, 4 static edges, 4 timestamps

julia> edges(g)
4-element Array{EvolvingGraphs.WeightedTimeEdge{EvolvingGraphs.Node{Int64},Int64,Float64},1}:
 Node(1)-1.0->Node(2) at time 2001
 Node(2)-1.0->Node(1) at time 2003
 Node(5)-1.0->Node(6) at time 2007
 Node(3)-1.0->Node(4) at time 2008
```
"""
function sort_timestamps!(g::EvolvingGraph)
    p = sortperm(g.timestamps)
    g.edges = g.edges[p]
    g.timestamps = g.timestamps[p]
    g
end

"""
    sort_timestamps(g)

Sort evolving graph `g` according to timestamps, return a new sorted evolving graph.
"""
sort_timestamps(g::EvolvingGraph) = sort_timestamps!(deepcopy(g))

"""
    slice_timestamps!(g, t_min, t_max)

Slice an (sorted) evolving graph `g` between timestamp `t_min` and `t_max.`
"""
function slice_timestamps!{V,E,T}(g::EvolvingGraph{V,E,T}, t_min::T, t_max::T)
    issorted(g) || sorttime!(g)
    a = findfirst(g.timestamps, t_min)
    b = findlast(g.timestamps, t_max)
    g.edges = g.edges[a:b]
    g.timestamps =  g.timestamps[a:b]
    g
end

"""
    slice_timestamps(g, t_min, t_max)

Slice an (sorted) evolving graph `g` between timestamp `t_min` and `t_max.`, return a new evolving graph.

```jldoctest
julia> using EvolvingGraphs

julia> g = EvolvingGraph()
Directed EvolvingGraph 0 nodes, 0 static edges, 0 timestamps

julia> add_bunch_of_edges!(g, [(1,2,1), (2,3,1), (1,4,2), (2,3,3), (3,4,5)])
Directed EvolvingGraph 4 nodes, 5 static edges, 4 timestamps

julia> g2 = slice_timestamps(g, 2,3)
Directed EvolvingGraph 4 nodes, 2 static edges, 2 timestamps

julia> edges(g)
5-element Array{EvolvingGraphs.WeightedTimeEdge{EvolvingGraphs.Node{Int64},Int64,Float64},1}:
 Node(1)-1.0->Node(2) at time 1
 Node(2)-1.0->Node(3) at time 1
 Node(1)-1.0->Node(4) at time 2
 Node(2)-1.0->Node(3) at time 3
 Node(3)-1.0->Node(4) at time 5

julia> edges(g2)
2-element Array{EvolvingGraphs.WeightedTimeEdge{EvolvingGraphs.Node{Int64},Int64,Float64},1}:
 Node(1)-1.0->Node(4) at time 2
 Node(2)-1.0->Node(3) at time 3
```

"""
function slice_timestamps{V,E,T}(g::EvolvingGraph{V,E,T}, t_min::T, t_max::T)
    slice_timestamps!(deepcopy(g), t_min, t_max)
end
