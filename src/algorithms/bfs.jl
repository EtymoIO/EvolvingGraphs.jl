"""
    breadth_first_impl(g,i)

Find all the reachable node from TimeNode `i` using BFS.

# Example

```
julia> using EvolvingGraphs

julia> g = EvolvingGraph{Node{String}, Int}()
Directed EvolvingGraph 0 nodes, 0 static edges, 0 timestamps

julia> add_bunch_of_edges!(g, [("A", "B", 1), ("B", "F", 1), ("B", "G", 1), ("C", "E", 2), ("E", "G", 2), ("A", "B", 2), ("A", "B", 3), ("C", "F", 3), ("E","G", 3)])
Directed EvolvingGraph 6 nodes, 9 static edges, 3 timestamps

julia> breadth_first_impl(g, "A", 1)
Dict{EvolvingGraphs.TimeNode{String,Int64},Int64} with 14 entries:
  TimeNode(B, 3) => 2
  TimeNode(B, 3) => 2
  TimeNode(A, 2) => 1
  TimeNode(F, 1) => 2
  TimeNode(G, 3) => 3
  TimeNode(A, 3) => 1
  TimeNode(A, 1) => 0
  TimeNode(F, 3) => 3
  TimeNode(B, 3) => 3
  TimeNode(G, 1) => 2
  TimeNode(B, 2) => 2
  TimeNode(B, 2) => 2
  TimeNode(G, 2) => 3
  TimeNode(B, 1) => 1
```

"""
function breadth_first_impl(g::Union{AbstractEvolvingGraph, IntAdjacencyList}, v::Union{TimeNode,Tuple{Int,Int}})
    level = Dict(v => 0)
    i = 1
    fronter = [v]
    while length(fronter) > 0
        next = []
        for u in fronter
            for v in forward_neighbors(g, u)
                if !(v in keys(level))
                    level[v] = i
                    push!(next, v)
                end
            end
        end
        fronter = next
        i += 1
    end
    level
end
function breadth_first_impl{V,E,T,KV}(g::EvolvingGraph{V,E,T,KV}, key_v::KV, t_v::T)
    if !((key_v, t_v) in keys(g.active_node_indexof))
        return []
    end
    index_v = g.active_node_indexof[(key_v, t_v)]
    v = TimeNode(index_v, key_v, t_v)
    return breadth_first_impl(g, v)
end

function breadth_first_impl(g::IntAdjacencyList, key_v::Int, t_v::Int)
    return breadth_first_impl(g, (key_v, t_v))
end
