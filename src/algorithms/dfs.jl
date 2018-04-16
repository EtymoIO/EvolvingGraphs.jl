"""
    depth_first_impl(g, i, j, verbose = true)
    depth_first_impl(g, i_key, i_t, j_key, j_t, verbose = true)

Find the shortest temporal path between TimeNode `i` and `j` on an evolving graph `g` using DFS. Alternatively, we could inpute the node keys `i_key`, `j_key` and node timestamps `i_t`, `j_t` respectively.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> g = EvolvingGraph{Node{String}, Int}()
Directed EvolvingGraph 0 nodes, 0 static edges, 0 timestamps

julia> add_bunch_of_edges!(g, [("A", "B", 1), ("B", "F", 1), ("B", "G", 1), ("C", "E", 2), ("E", "G", 2), ("A", "B", 2), ("A", "B", 3), ("C", "F", 3), ("E","G", 3)])
Directed EvolvingGraph 6 nodes, 9 static edges, 3 timestamps

julia> depth_first_impl(g, "A", 1, "F", 3)
Current path: TimeNode(A, 1)
Current path: TimeNode(A, 1)->TimeNode(B, 1)
Current path: TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(F, 1)
Current path: TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(F, 1)->TimeNode(F, 3)
Current path: TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(G, 1)
Current path: TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(G, 1)->TimeNode(G, 2)
Current path: TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(G, 1)->TimeNode(G, 3)
Current path: TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(B, 2)
Current path: TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(B, 2)->TimeNode(B, 3)
Current path: TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(B, 3)
Current path: TimeNode(A, 1)->TimeNode(A, 2)
Current path: TimeNode(A, 1)->TimeNode(A, 2)->TimeNode(B, 2)
Current path: TimeNode(A, 1)->TimeNode(A, 2)->TimeNode(B, 2)->TimeNode(B, 3)
Current path: TimeNode(A, 1)->TimeNode(A, 2)->TimeNode(A, 3)
Current path: TimeNode(A, 1)->TimeNode(A, 2)->TimeNode(A, 3)->TimeNode(B, 3)
Current path: TimeNode(A, 1)->TimeNode(A, 3)
Current path: TimeNode(A, 1)->TimeNode(A, 3)->TimeNode(B, 3)
TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(F, 1)->TimeNode(F, 3)
```
"""
function depth_first_impl(g::Union{AbstractEvolvingGraph, IntAdjacencyList}, i::Union{TimeNode, Tuple{Int,Int}}, j::Union{TimeNode, Tuple{Int,Int}}, p = TemporalPath(), shortest = TemporalPath(); verbose = true)

    p = deepcopy(p)
    push!(p, i)
    if verbose
        println("Current path: $(p)")
    end

    if i == j
        return p
    end

    for n in forward_neighbors(g, i)
        if !(n in p)
            n_t = typeof(n) <: TimeNode ? node_timestamp(n) : n[2]
            j_t = typeof(j) <: TimeNode ? node_timestamp(j) : j[2]
            if n_t <= j_t
                if shortest == TemporalPath() || (length(p) < length(shortest))
                    new_p = depth_first_impl(g, n, j, p, shortest, verbose = verbose)
                    if new_p != TemporalPath()
                        shortest = new_p
                    end
                end
            end
        end
    end
    return shortest

end
function depth_first_impl{V,E,T,KV}(g::EvolvingGraph{V,E,T,KV}, key_i::KV, t_i::T, key_j::KV, t_j::T)
    if !((key_i, t_i) in keys(g.active_node_indexof)) || !((key_j, t_j) in keys(g.active_node_indexof))
        return p
    end

    index_i = g.active_node_indexof[(key_i, t_i)]
    index_j = g.active_node_indexof[(key_j, t_j)]

    i = TimeNode(index_i, key_i, t_i)
    j = TimeNode(index_j, key_j, t_j)
    return depth_first_impl(g, i, j)
end

function depth_first_impl(g::IntAdjacencyList, key_i::Int, t_i::Int, key_j::Int, t_j::Int)
    return depth_first_impl(g, (key_i, t_i), (key_j, t_j))
end
