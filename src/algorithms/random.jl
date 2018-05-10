"""

    random_graph(n,p=0.5, has_self_loops=false)

generate a random directed graph `g` with `n` nodes and the probability to include edge is `p`. If `has_self_loops`, `g` will include self loops.
"""
function random_graph(n::Integer, p::Real = 0.5; has_self_loops = false)
    g = DiGraph()
    for i = 1:n
        ind = 1
        for j = ind:n
            add_node!(g, j)
            if rand() <= p && (i != j || has_self_loops)
                add_edge!(g, i, j)
            end
        end
    end
    return g
end

"""
    random_evolving_graph(nn, nt, p=0.5, is_directed=true, has_self_loops=false)
    random_evolving_graph(g, nn, nt, p=0.5, is_directed=true, has_self_loops=false)

Generate a random evolving graph `g` with `nn` nodes, `nt` timestamps. The random evolving graph has integer nodes and timestamps.
 The probability to include each edge is equal to `p`. If `has_self_loops`, we allow `g` to have self loops. If `g` is not given, we generate a random IntAdjacencyList evolving graph.

# Example

```
julia> using EvolvingGraphs

julia> random_evolving_graph(10, 4, 0.1)
Directed IntAdjacencyList (10 nodes, 37 static edges, 4 timestamps)

julia> g = EvolvingGraph()
Directed EvolvingGraph 0 nodes, 0 static edges, 0 timestamps

julia> random_evolving_graph(g, 20, 3, 0.5)
Directed EvolvingGraph 20 nodes, 558 static edges, 3 timestamps
```
"""
function random_evolving_graph(g::AbstractEvolvingGraph, nn::Int, nt::Int, p::Real = 0.5;
                               has_self_loops = false)
    for t in 1:nt
        for i = 1:nn
            is_directed(g) ? ind =1 : ind = i
            for j = ind:nn
                    if (rand() <= p && (i != j || has_self_loops))
                        add_edge!(g, i, j, t)
                    end
            end
        end
    end
    g
end
function random_evolving_graph(nn::Int, nt::Int,p::Real = 0.5;
                               is_directed = true,has_self_loops  = false)
    g = IntAdjacencyList(nn, nt, is_directed = is_directed)
    random_evolving_graph(g, nn, nt, p, has_self_loops = has_self_loops)
end
