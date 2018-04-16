"""
    katz(g, alpha = 0.1)

Compute the Katz centrality for a static graph `g`.

# References:

1. L. Katz A new index derived from sociometric data analysis. Psychometrika, 18:39-43, 1953.
"""
function katz(g::AbstractStaticGraph, alpha::Real = 0.1)
    n = num_nodes(g)
    ns = nodes(g)
    v = ones(Float64, n)
    A = sparse_adjacency_matrix(g)
    spI = speye(Float64, n)
    rates = (spI - alpha * A)\v
    return [(node, rates[node.index]) for node in ns]
end



"""
    katz(g, alpha = 0.3)
    katz(g, alpha, beta; mode = :broadcast)

Computes the katz centrality for an evolving graph `g`, where `alpha` and `beta` are scalars. `alpha` controls the influence of long walks and `beta` controls the influence of walks happened long time ago. By default, `mode = :broadcast` computes the broadcast centrality. Otherwise if `mode = :receive`, we compute the receiving centrality.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> using EvolvingGraphs.Centrality

julia> g = evolving_graph_from_arrays(["A", "B", "B", "C", "E", "A", "B", "D"], ["B", "F", "G", "E", "G", "B", "F", "F"], [1,1,1,2,2,2,2,2])
Directed EvolvingGraph 7 nodes, 8 static edges, 2 timestamps

julia> katz(g)
7-element Array{Tuple{EvolvingGraphs.Node{String},Float64},1}:
 (Node(A), 0.776825)
 (Node(B), 0.3916)
 (Node(F), 0.0910698)
 (Node(G), 0.0910698)
 (Node(C), 0.350619)
 (Node(E), 0.227674)
 (Node(D), 0.227674)

julia> katz(g, 0.3, 0.4, mode = :receive)
7-element Array{Tuple{EvolvingGraphs.Node{String},Float64},1}:
 (Node(A), 0.0)
 (Node(B), 0.441673)
 (Node(F), 1.0)
 (Node(G), 0.548645)
 (Node(C), 0.0)
 (Node(E), 0.42231)
 (Node(D), 0.0)
```

# References:

1. P. Grindrod, D. J. Higham, M. C. Parsons and E. Estrada Communicability across evolving networks. Physical Review E, 83 2011.

2. P. Grindrod and D. J. Higham, A matrix iteration for dynamic network summaries. SIAM Review, 55 2013.
"""
function katz(g::AbstractEvolvingGraph, alpha::Real = 0.3)
    n = num_nodes(g)
    ns = nodes(g)
    ts = timestamps(g)
    v = ones(Float64, n)
    A = spzeros(Float64, n, n)
    spI = speye(Float64, n)
    for t in ts
        A =  sparse_adjacency_matrix(g,t)
        v = (spI - alpha*A)\v
        v =  v/norm(v)
    end
    return [(node, v[node.index]) for node in ns]
end

function katz(g::AbstractEvolvingGraph, alpha::Real, beta::Real; mode::Symbol = :broadcast)
    n = num_nodes(g)
    ns = nodes(g)
    ts = timestamps(g)
    S = spzeros(Float64, n, n)
    A = spzeros(Float64, n, n)
    spI = speye(Float64, n)
    v = Array{Float64}(n)
    Δt = 1.
    for t in ts
        Δt += 0.01
        A =  sparse_adjacency_matrix(g,t)
        S =  (spI + e^( -beta * Δt) * S) * (spI + alpha * A) - spI
        S =  S/norm(S,1)
    end

    v = mode == :broadcast ? S * ones(Float64,n) : S' * ones(Float64,n)

    return [(node, v[node.index]) for node in ns]
end
