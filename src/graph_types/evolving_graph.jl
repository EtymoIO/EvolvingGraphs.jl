"""
    EvolvingGraph{V,T}(;is_directed=true; is_weighted=true)
    EvolvingGraph(;is_directed=true; is_weighted=true)

Construct an evolving graph with node type `V` and timestamp type `T`.
`EvolvingGraph()` constructs a simple evolving graph with integer nodes and timestamps.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> g = EvolvingGraph{Node{String},Int}(is_weighted=false)
Directed EvolvingGraph 0 nodes, 0 static edges, 0 timestamps

julia> add_node!(g, "a")
Node(a)

julia> add_node!(g, "b")
Node(b)

julia> num_nodes(g)
2

julia> add_edge!(g, "a", "b", 2001)
Node(a)->Node(b) at time 2001

julia> add_edge!(g, "a", "c", 2002)
Node(a)->Node(c) at time 2002

julia> timestamps(g)
2-element Array{Int64,1}:
 2001
 2002

julia> active_nodes(g)
4-element Array{EvolvingGraphs.TimeNode{String,Int64},1}:
 TimeNode(a, 2001)
 TimeNode(b, 2001)
 TimeNode(a, 2002)
 TimeNode(c, 2002)

julia> g = EvolvingGraph()
Directed EvolvingGraph 0 nodes, 0 static edges, 0 timestamps

julia> add_edge!(g, 1, 2, 1)
Node(1)-1.0->Node(2) at time 1

julia> add_edge!(g, 2, 3, 2)
Node(2)-1.0->Node(3) at time 2

julia> add_edge!(g, 1, 3, 2)
Node(1)-1.0->Node(3) at time 2

julia> nodes(g)
3-element Array{EvolvingGraphs.Node{Int64},1}:
 Node(1)
 Node(2)
 Node(3)
```
"""
mutable struct EvolvingGraph{V, E, T, KV} <: AbstractEvolvingGraph{V, E, T}
    is_directed::Bool
    nodes::Vector{V}             # a vector of nodes
    node_indexof::Dict{KV, Int}   # map node keys to indices
    edges::Vector{E}           # a vector of edges
    timestamps::Vector{T}           # a vector of timestamps
    active_nodes::Vector{TimeNode{KV,T}}  # a vector of active nodes
    active_node_indexof::Dict{Tuple{KV,T},Int} # mapping active node keys to indices
end

function EvolvingGraph{V,T}(;is_directed::Bool=true, is_weighted::Bool=true) where {V,T}
    KV = eltype(V);
    E = is_weighted ? WeightedTimeEdge{V,T,Float64} : TimeEdge{V,T};
    return EvolvingGraph(is_directed, V[], Dict{KV, Int}(), E[], T[], TimeNode{KV, T}[], Dict{Tuple{KV,T},Int}())
end
EvolvingGraph(;is_directed::Bool=true, is_weighted::Bool=true) = EvolvingGraph{Node{Int},Int}(is_directed=is_directed, is_weighted=is_weighted)



"""
    evolving_graph_from_arrays(ils, jls, wls, timestamps; is_directed=true)
    evolving_graph_from_arrays(ils, jls, timestamps; is_directed=true)

Generate an EvolvingGraph type object from four input arrays: `ils`, `jls`, `wls` and `timestamps`, such that the ith entry `(ils[i], jls[i], wls[i], timestamps[i])` represents a WeightedTimeEdge from `ils[i]` to `jls[i]` with edge weight `wls[i]` at timestamp `timestamp[i]`. By default, `wls` is a vector of ones.

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
3-element Array{EvolvingGraphs.WeightedTimeEdge{EvolvingGraphs.Node{Int64},Int64,Float64},1}:
 Node(1)-1.0->Node(4) at time 1
 Node(2)-1.0->Node(5) at time 1
 Node(3)-1.0->Node(2) at time 2

julia> g = evolving_graph_from_arrays([1,2], [2, 3], [2.5, 3.8], [1998,2001])
Directed EvolvingGraph 3 nodes, 2 static edges, 2 timestamps

julia> edges(g)
2-element Array{EvolvingGraphs.WeightedTimeEdge{EvolvingGraphs.Node{Int64},Int64,Float64},1}:
 Node(1)-2.5->Node(2) at time 1998
 Node(2)-3.8->Node(3) at time 2001
```
"""
function evolving_graph_from_arrays{V,T}(ils::Vector{V},
                            jls::Vector{V}, wls::Vector{<:Real},
                            timestamps::Vector{T};
                            is_directed::Bool = true)
    n = length(ils)
    n == length(jls) == length(timestamps) == length(wls)||
            error("4 input vectors must have the same length.")

    g = EvolvingGraph{Node{eltype(ils)}, eltype(timestamps)}(is_directed = is_directed)

    for i = 1:n
        v1 = add_node!(g, ils[i])
        v2 = add_node!(g, jls[i])
        w = wls[i]
        add_edge!(g, v1, v2, timestamps[i], weight = w)
    end
    g
end
evolving_graph_from_arrays{V,T}(ils::Vector{V}, jls::Vector{V}, timestamps::Vector{T}; is_directed::Bool = true) = evolving_graph_from_arrays(ils, jls, ones(Float64,length(ils)), timestamps, is_directed = is_directed)

"""
    evolving_graph_from_edges(edges; is_directed::Bool = true)

Generate an evolving graph from an array of edges.
"""
function evolving_graph_from_edges(edges::Vector{<:AbstractEdge}; is_directed::Bool = true)
    E = eltype(edges)
    is_weighted = E <: WeightedTimeEdge ? true : false

    types = eltype(E)

    g = EvolvingGraph{types[1], types[2]}(is_directed = is_directed, is_weighted = is_weighted)

    for e in edges
        is_weighted? add_edge!(g, source(e), target(e), edge_timestamp(e), weight = edge_weight(e)) : add_edge!(g, source(e), target(e), edge_timestamp(e))
    end
    return g
end

deepcopy(g::EvolvingGraph) = EvolvingGraph(is_directed(g),
                                           deepcopy(g.nodes),
                                           deepcopy(g.edges),
                                           deepcopy(g.timestamps),
                                           deepcopy(g.node_indexof),
                                           deepcopy(g.active_nodes),
                                           deepcopy(g.active_node_indexof))

eltype{V,E,T,I}(g::EvolvingGraph{V,E,T,I}) = (V,E,T,I)

is_directed(g::EvolvingGraph) = g.is_directed


nodes(g::EvolvingGraph) = g.nodes
num_nodes(g::EvolvingGraph) = length(nodes(g))


has_node{V}(g::EvolvingGraph{V}, v::V) = v in g.nodes
has_node{V, E, T, KV}(g::EvolvingGraph{V, E, T, KV}, node_key::KV) = node_key in g.node_indexof

unique_timestamps(g::EvolvingGraph) = unique(g.timestamps)
timestamps(g::EvolvingGraph) = g.timestamps
num_timestamps(g::EvolvingGraph) = length(unique_timestamps(g))


active_nodes(g::EvolvingGraph) = g.active_nodes
num_active_nodes(g::EvolvingGraph) = length(g.active_nodes)
has_active_node{V,E,T,KV}(g::EvolvingGraph{V,E,T,KV}, v::TimeNode{KV,T}) = v in g.active_nodes
has_active_node{V,E,T,KV}(g::EvolvingGraph{V,E,T,KV}, node_key::KV, node_timestamp::T) = (node_key, node_timestamp) in g.active_node_indexof

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
    g.node_indexof[v.key] = node_index(g,v)
    v
end
function add_node!{V, E, T, KV}(g::EvolvingGraph{V, E, T, KV}, key::KV)

    id = get(g.node_indexof, key, 0)

    if id == 0
        v = V(g, key)
        return add_node!(g, v)
    else
        return V(id, key)
    end
end


function find_node{V, E, T, KV}(g::EvolvingGraph{V, E, T, KV}, key::KV)
    try
        id = g.node_indexof[v]
        return V(id, v)
    catch
        return false
    end
end

find_node{V}(g::EvolvingGraph{V}, v::V) = v in g.nodes ? v : false



function add_edge!{V,E,T,KV}(g::EvolvingGraph{V,E,T,KV}, v1::KV, v2::KV, t::T; weight::Real = 1.0)
    v1 = add_node!(g, v1)
    v2 = add_node!(g, v2)

    add_edge!(g, v1, v2, t, weight = weight)
end


function add_edge!{V,E,T,KV}(g::EvolvingGraph{V,E,T,KV}, v1::V, v2::V, t::T; weight::Real = 1.0)

    e1 = E <: WeightedTimeEdge? E(v1, v2, weight, t) : E(v1, v2, t)
    if !(e1 in edges(g))

        # we only add active nodes when we add edges to the graph.
        if !((node_key(v1),t) in keys(g.active_node_indexof))
            n1 = TimeNode{KV,T}(g, v1.key, t)
            push!(g.active_nodes, n1)
            g.active_node_indexof[(node_key(v1),t)] = node_index(n1)
        end

        if !((node_key(v2),t) in keys(g.active_node_indexof))
            n2 = TimeNode{KV,T}(g, v2.key, t)
            push!(g.active_nodes, n2)
            g.active_node_indexof[(node_key(v2),t)] = node_index(n2)
        end

        push!(g.edges, e1)
        push!(g.timestamps, t)

        if !(is_directed(g))
            push!(g.edges, edge_reverse(e1))
            push!(g.timestamps, t)
        end
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




"""
    adjacency_matrix(g, t)

Return an adjacency matrix representation of an evolving graph `g` at timestamp `t`.

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
function adjacency_matrix{V, E, T}(g::EvolvingGraph{V, E, T}, t::T)
    n = num_nodes(g)
    es = edges(g, t)
    A = zeros(Float64, n, n)
    for e in es
        i = node_index(source(e))
        j = node_index(target(e))
        v = E <: WeightedTimeEdge ? e.weight : 1.0
        A[(j-1)*n + i] = v
    end
    return A
end


"""
    sparse_adjacency_matrix(g, t)

Return a sparse adjacency matrix representation of an evolving graph
`g` at timestamp `t`.

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
    vs = Float64[]
    es = edges(g, t)

    for e in es
        i = node_index(source(e))
        j = node_index(target(e))
        v = E <: WeightedTimeEdge ? e.weight : 1.0
        push!(is, i)
        push!(js, j)
        push!(vs, v)
    end

    return sparse(is, js, vs, n, n)
end


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
    forward_neighbors(g, v)

Find the forward neighbors of a node `v` in graph `g`. If `g` is an evolving graph,
we define the forward neighbors of a TimeNode `(v,t)` to be a collection of forward neighbors
at time stamp `t` and the same node key at later time stamps.

# References:

1.
"""
function forward_neighbors{V,E,T,KV}(g::EvolvingGraph{V,E,T,KV}, v::TimeNode)
    v_t = node_timestamp(v)
    v_key = node_key(v)
    node_index = g.node_indexof[v_key]
    ts = timestamps(g)



    for t in ts
        if t > v_t
            A = sparse_adjacency_matrix(g, t)
            row = A[node_index,:]
            col = A[:, node_index]
            if nonzero

            end
        end
    end
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
