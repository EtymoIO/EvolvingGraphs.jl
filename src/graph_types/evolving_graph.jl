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



deepcopy(g::EvolvingGraph) = EvolvingGraph(is_directed(g),
                                           deepcopy(g.nodes),
                                           deepcopy(g.node_indexof),
                                           deepcopy(g.edges),
                                           deepcopy(g.timestamps),
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
has_active_node{V,E,T,KV}(g::EvolvingGraph{V,E,T,KV}, v::TimeNode{KV,T}) =
v in g.active_nodes
has_active_node{V,E,T,KV}(g::EvolvingGraph{V,E,T,KV}, key::KV, t::T) =
get(g.active_node_indexof, (key,t), false) != false ? true : false

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


function add_bunch_of_edges!(g::EvolvingGraph, ebunch)
    for e in ebunch
        if length(e) == 3
            i,j,t = e
            add_edge!(g, i, j, t)
        elseif length(e) == 4
            i, j, t, w = e
            add_edge!(g, i, j, t, weight = w)
        else
            error("Each edge in ebunch must have 3 or 4 elements")
        end

    end
    return g
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
        A[i,j] = v
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



function neighbors{V,E,T,KV}(g::EvolvingGraph{V,E,T,KV}, v::TimeNode{KV,T}; mode::Symbol = :forward)
    r = TimeNode{KV,T}[]

    switch_mode = Dict(
        :forward => (source, target, >),
        :backward => (target, source, <)
    )

    this, that, compare = switch_mode[mode]

    if ! has_active_node(g,v)
        return r
    end

    v_t = node_timestamp(v)
    v_key = node_key(v)

    for e in edges(g)

        # forword neighbors at timestamp v_t
        if edge_timestamp(e) == v_t
            if node_key(this(e)) == v_key
                v_key_new = node_key(that(e))
                v_index = g.active_node_indexof[(v_key_new,v_t)]
                n = TimeNode(v_index, v_key_new, v_t)
                if !(n in r)
                    push!(r, n)
                end
            end
        end

        if compare(edge_timestamp(e), v_t)
            if node_key(source(e)) == v_key || node_key(target(e)) == v_key
                v_t_new = edge_timestamp(e)
                v_index = g.active_node_indexof[(v_key, v_t_new)]
                n = TimeNode(v_index, v_key, v_t_new)
                if !(n in r)
                    push!(r, n)
                end
            end
        end
    end
    return r
end


forward_neighbors{V,E,T,KV}(g::EvolvingGraph{V,E,T,KV}, v::TimeNode{KV,T}) = neighbors(g, v, mode = :forward)

backward_neighbors{V,E,T,KV}(g::EvolvingGraph{V,E,T,KV}, v::TimeNode{KV,T}) = neighbors(g, v, mode = :backward)



"""
    add_graph!(eg, g, t)

Add a static graph `g` at timestamp `t` to an evolving graph `eg`.
"""
function add_graph!{V, E, T}(eg::EvolvingGraph{V, E, T}, g::AbstractStaticGraph, t::T)
    es = edges(g)
    for e in es
        add_edge!(eg, node_key(source(e)), node_key(target(e)), t)
    end
    eg
end
