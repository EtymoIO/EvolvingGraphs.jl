"""
    EvolvingGraph{V,T}(is_directed = true)


Construct an evolving graph with node type `V` and timestamp type `T`.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> g = EvolvingGraph{Node{Int}, Int}()
Directed EvolvingGraph 0 nodes, 0 static edges, 0 timestamps

julia> add_node!(g, 1)
Node(1)

julia> add_node!(g, 2)
Node(2)

julia> num_nodes(g)
2

julia> add_edge!(g,1,2,1)
Node(1)->Node(2) at time 1

julia> add_edge!(g,1,3,2)
Node(1)->Node(3) at time 2

julia> timestamps(g)
2-element Array{Int64,1}:
 1
 2
```
"""
mutable struct EvolvingGraph{V, E, T, KV} <: AbstractEvolvingGraph{V, E, T}
    is_directed::Bool
    nodes::Vector{V}                      # a vector of nodes
    edges::Vector{E}                # a vector of edges
    timestamps::Vector{T}                      # a vector of timestamps
    indexof::Dict{KV, Int}                   # map node keys to indices
    active_nodes::Vector{TimeNode{KV,T}}         # a vector of active nodes
end

function EvolvingGraph{V,T}(;is_directed::Bool=true) where {V,T}
    KV = eltype(V);
    E = TimeEdge{V, T};
    return EvolvingGraph(is_directed, V[], E[], T[], Dict{KV, Int}(),TimeNode{KV, T}[])
end




"""
    evolving_graph_from_arrays(ils, jls, timestamps; is_directed=true)

Generate an EvolvingGraph type object from three input arrays: ils, jls and timestamps, such that
the ith entry `(ils[i], jls[i] and timestamps[i])` is a TimeEdge from `ils[i]` to `jls[i]` at timestamp
`timestamp[i]`.

#  Example

```jldoctest
julia> using EvolvingGraphs

julia> g = evolving_graph_from_arrays([1,2,3], [4,5,2], [1,1,2])
Directed EvolvingGraph 5 nodes, 3 static edges, 2 timestamps

julia> nodes(g)
5-element Array{EvolvingGraphs.Node{Int64},1}:
 Node(1)
 Node(4)
 Node(2)
 Node(5)
 Node(3)

julia> edges(g)
3-element Array{EvolvingGraphs.TimeEdge{EvolvingGraphs.Node{Int64},Int64},1}:
 Node(1)->Node(4) at time 1
 Node(2)->Node(5) at time 1
 Node(3)->Node(2) at time 2
```
"""
function evolving_graph_from_arrays{V,T}(ils::Vector{V},
                            jls::Vector{V},
                            timestamps::Vector{T};
                            is_directed::Bool = true)
    n = length(ils)
    n == length(jls) == length(timestamps)||
            error("3 input vectors must have the same length.")

    g = EvolvingGraph{Node{eltype(ils)}, eltype(timestamps)}(is_directed = is_directed)

    for i = 1:n
        v1 = add_node!(g, ils[i])
        v2 = add_node!(g, jls[i])
        add_edge!(g, v1, v2, timestamps[i])
    end
    g
end

deepcopy(g::EvolvingGraph) = EvolvingGraph(is_directed(g),
                                           deepcopy(g.nodes),
                                           deepcopy(g.edges),
                                           deepcopy(g.timestamps),
                                           deepcopy(g.indexof),
                                           deepcopy(g.active_nodes))

eltype{V,E,T,I}(g::EvolvingGraph{V,E,T,I}) = (V,E,T,I)

is_directed(g::EvolvingGraph) = g.is_directed


nodes(g::EvolvingGraph) = g.nodes
num_nodes(g::EvolvingGraph) = length(nodes(g))


has_node{V}(g::EvolvingGraph{V}, v::V) = v in g.nodes
has_node{V, E, T, KV}(g::EvolvingGraph{V, E, T, KV}, node_key::KV) = v in g.indexof

unique_timestamps(g::EvolvingGraph) = unique(g.timestamps)
timestamps(g::EvolvingGraph) = g.timestamps
num_timestamps(g::EvolvingGraph) = length(unique_timestamps(g))


active_nodes(g::EvolvingGraph) = g.active_nodes
num_active_nodes(g::EvolvingGraph) = length(g.active_nodes)

edges(g::EvolvingGraph) = g.edges
function edges(g::EvolvingGraph, t)
    inds = findin(g.timestamps, [t])
    if length(inds) == 0
        error("unknown timestamp $(t)")
    end
    return g.edges[inds]
end


num_edges(g::EvolvingGraph) = length(g.edges)



function add_node!{V}(g::EvolvingGraph{V}, v::V)
    push!(g.nodes, v)
    g.indexof[v.key] = node_index(g,v)
    v
end
function add_node!{V}(g::EvolvingGraph{V}, key)

    id = get(g.indexof, key, 0)

    if id == 0
        v = V(g, key)
        return add_node!(g, v)
    else
        return V(id, key)
    end
end

function find_node{V}(g::EvolvingGraph{V}, key)
    try
        id = g.indexof[v]
        return V(id, v)
    catch
        return false
    end
end

find_node{V}(g::EvolvingGraph{V}, v::V) = v in g.nodes ? v : false



function add_edge!{V, E, T, KV}(g::EvolvingGraph{V, E, T, KV}, v1::KV, v2::KV, t::T)
    v1 = add_node!(g, v1)
    v2 = add_node!(g, v2)
    e1 = E(v1, v2, t)
    if !(e1 in edges(g))
        add_edge!(g, v1, v2, t)
    end
    e1
end

function add_edge!{V,E,T,KV}(g::EvolvingGraph{V,E,T,KV}, v1::V, v2::V, t::T)
    n1 = TimeNode{KV,T}(g, v1.key, t)
    n2 = TimeNode{KV,T}(g, v2.key, t)
    e1 = E(v1, v2, t)
    push!(g.active_nodes, n1)
    push!(g.active_nodes, n2)
    push!(g.edges, e1)
    push!(g.timestamps, t)

    if !(is_directed(g))
        push!(g.edges, edge_reverse(e1))
        push!(g.timestamps, t)
    end
    return e1
end



function add_edge_from_array!{V, E, T, KV}(g::EvolvingGraph{V, E, T, KV},
                                        v1::Array{KV}, v2::Array{KV}, t::T)
    for j in v2
        for i in v1
            add_edge!(g, i, j, t)
        end
    end
    g
end

has_edge{V, E}(g::EvolvingGraph{V,E}, e::E) = e in edges(g)




"""
    adjacency_matrix(g, t[, T = Bool])

Return an adjacency matrix representation of an evolving graph `g` at timestamp `t`.
`T` (default=Float64) is the element type of the matrix.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> g = evolving_graph_from_arrays([1,2,3], [4,5,2], [1,1,2])
Directed EvolvingGraph 5 nodes, 3 static edges, 2 timestamps

julia> adjacency_matrix(g, 1)
5×5 Array{Float64,2}:
 0.0  1.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  1.0  0.0
 0.0  0.0  0.0  0.0  0.0
 0.0  0.0  0.0  0.0  0.0
```
"""
function adjacency_matrix{V, E, T}(g::EvolvingGraph{V, E, T}, t::T, M::Type = Float64)
    n = num_nodes(g)
    es = edges(g, t)
    A = zeros(M, n, n)
    for e in es
        i = node_index(e.source)
        j = node_index(e.target)
        A[(j-1)*n + i] = one(M)
    end
    return A
end

# function adjacency_matrix{V, T, E <: WeightedTimeEdge}(g::EvolvingGraph{V, T, E}, t, M::Type = Float64)
#     n = num_nodes(g)
#     es = edges(g, t)
#     A = zeros(M, n, n)
#     for e in es
#         i = node_index(e.source)
#         j = node_index(e.target)
#         w = e.weight
#         A[(j-1)*n + i] = M(w)
#     end
#     return A
# end

"""
    sparse_adjacency_matrix(g, t[, T = Bool])

Return a sparse adjacency matrix representation of an evolving graph
`g` at timestamp `t`. `T` (default=Float64) is the element type of the matrix.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> g = evolving_graph_from_arrays([1,2,3], [4,5,2], [1,1,2])
Directed EvolvingGraph 5 nodes, 3 static edges, 2 timestamps

julia> sparse_adjacency_matrix(g,2)
5×5 SparseMatrixCSC{Float64,Int64} with 1 stored entry:
  [5, 3]  =  1.0

julia> sparse_adjacency_matrix(g,1)
5×5 SparseMatrixCSC{Float64,Int64} with 2 stored entries:
  [1, 2]  =  1.0
  [3, 4]  =  1.0
```
"""
function sparse_adjacency_matrix{V,E,T}(g::EvolvingGraph{V,E,T}, t::T, M::Type = Float64)
    n = num_nodes(g)
    is = Int[]
    js = Int[]
    es = edges(g, t)
    for e in es
        i = node_index(e.source)
        j = node_index(e.target)
        push!(is, i)
        push!(js, j)
    end
    vs = ones(M, length(is))
    return sparse(is, js, vs, n, n)
end

# function sparse_adjacency_matrix{V, T, E <: WeightedTimeEdge}(g::EvolvingGraph{V, T, E}, t, M::Type = Float64)
#     n = num_nodes(g)
#     is = Int[]
#     js = Int[]
#     ws = M[]
#     es = edges(g, t)
#     for e in es
#         i = node_index(e.source)
#         j = node_index(e.target)
#         w = T(e.weight)
#         push!(is, i)
#         push!(js, j)
#         push!(ws, w)
#     end
#     return sparse(is, js, ws, n, n)
# end

"""
    forward_neighbors(g, v, t)

Return the forward neighbors of temporal node `(v,t)`.
"""
function forward_neighbors{V, T}(g::EvolvingGraph{V, T}, v, t)
    neighbors = Tuple{V, T}[]
    v = find_node(g, v)
    return forward_neighbors(g, v, T(t))
end
forward_neighbors(g::EvolvingGraph, v::Tuple) = forward_neighbors(g, v[1], v[2])
function forward_neighbors{V, T}(g::EvolvingGraph{V, T}, v::V, t::T)
    neighbors = Tuple{V, T}[]
    if !(TimeNode(v, t) in active_nodes(g))
        return neighbors   # if (v, t) is not active, return an empty list.
    end
    for e in edges(g)
        if v == e.source
            if t == e.timestamp
                push!(neighbors, (e.target, t))   # neighbors at timestamp t
            elseif t < e.timestamp
                push!(neighbors, (e.source, e.timestamp))  # v itself at later timestamps
            end
        elseif v == e.target
            if t < e.timestamp
                push!(neighbors, (e.target, e.timestamp))  # v itself at later timestamps
            end
        end
    end
    neighbors
end
"""
    backward_neighbors(g, v, t)

Return the backward neighbors of temporal node `(v,t)`.
"""
function backward_neighbors{V, T}(g::EvolvingGraph{V, T}, v::V, t::T)
    error("not implemented yet!")
end


"""
    add_graph!(eg, g, t)

Add a static graph `g` at timestamp `t` to an evolving graph `eg`.
"""
function add_graph!{V, T}(eg::EvolvingGraph{V, T}, g::AbstractStaticGraph, t::T)
    es = edges(g)
    for e in es
        add_edge!(eg, source(e), target(e), t)
    end
    eg
end
