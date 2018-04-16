"""
    DiGraph{V,E}()
    DiGraph{V}()
    DiGraph()

Construct a static directed graph with node type `V` and edge type `E`. `DiGraph()` constructs a static directed graph with integer nodes and edges.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> g = DiGraph()
DiGraph 0 nodes, 0 edges

julia> add_edge!(g, 1, 2)
Node(1)->Node(2)

julia> add_edge!(g, 2, 3)
Node(2)->Node(3)

julia> adjacency_matrix(g)
3×3 Array{Float64,2}:
 0.0  1.0  0.0
 0.0  0.0  1.0
 0.0  0.0  0.0

julia> add_node!(g, 4)
Node(4)

julia> nodes(g)
4-element Array{EvolvingGraphs.Node{Int64},1}:
 Node(1)
 Node(2)
 Node(3)
 Node(4)
```
"""
mutable struct DiGraph{V<:AbstractNode, E<:AbstractEdge, IncList, VK} <: AbstractStaticGraph{V, E}
    nodes::Vector{V}
    edges::Vector{E}
    forward_ilist::IncList # forward incidence list
    backward_ilist::IncList # backward incidence list
    indexof::Dict{VK,Int}
end
DiGraph{V, E}() where V where E = DiGraph(V[], E[], [], [], Dict{eltype(V), Int}())
DiGraph{V}() where V = DiGraph{V, Edge{V}}()
DiGraph() = DiGraph{Node{Int}, Edge{Node{Int}}}()


nodes(g::DiGraph) = g.nodes
num_nodes(g::DiGraph) = length(g.nodes)
edges(g::DiGraph) = g.edges
num_edges(g::DiGraph) = length(g.edges)


function add_bunch_of_edges!(g::DiGraph, ebunch)
    for e in ebunch
        if length(e) == 2
            i,j = e
            add_node!(g,i)
            add_node!(g,j)
            add_edge!(g,i,j)
        else
            error("Each edge in ebunch must have 2 elemnts: source and target")
        end
    end
    g
end

"""
    out_edges(g, v)

Return the outward edges of node `v` in a static graph `g`, where `v` can be a node or a node key.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> g = DiGraph()
DiGraph 0 nodes, 0 edges

julia> add_bunch_of_edges!(g, [(1,2), (2,3), (3,4)])
DiGraph 4 nodes, 3 edges

julia> out_edges(g, 1)
1-element Array{EvolvingGraphs.Edge{EvolvingGraphs.Node{Int64}},1}:
 Node(1)->Node(2)
```
"""
out_edges{V}(g::DiGraph{V}, v::V) = g.forward_ilist[node_index(v)]
out_edges{V}(g::DiGraph{V}, key::eltype(V)) = (v = Node(g.indexof[key],key); out_edges(g, v))


"""
    out_degree(g, v)

Return the number of outward edges of node `v` in static graph `g`, where `v` can be a node of a node key.
"""
out_degree{V}(g::DiGraph{V}, v::V) = length(out_edges(g, v))
out_degree{V}(g::DiGraph{V}, key::eltype(V)) = (v = Node(g.indexof[key],key); out_degree(g, v))

"""
    in_edges(g, v)

Return the inward edges of node `v` in static graph `g`.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> g = DiGraph()
DiGraph 0 nodes, 0 edges

julia> add_bunch_of_edges!(g, [(2,1), (3,1), (4,1)])
DiGraph 4 nodes, 3 edges

julia> in_edges(g,1)
3-element Array{EvolvingGraphs.Edge{EvolvingGraphs.Node{Int64}},1}:
 Node(2)->Node(1)
 Node(3)->Node(1)
 Node(4)->Node(1)

julia> in_degree(g,1)
3
```
"""
in_edges{V}(g::DiGraph{V}, v::V) = g.backward_ilist[node_index(v)]
in_edges{V}(g::DiGraph{V}, key::eltype(V)) = (v = Node(g.indexof[key],key); in_edges(g, v))

"""
    in_degree(g, v)

Return the number of inward edges of node `v` in static graph `g`.
"""
in_degree{V}(g::DiGraph{V}, v::V) = length(in_edges(g, v))
in_degree{V}(g::DiGraph{V}, key::eltype(V)) = (v = Node(g.indexof[key],key); in_degree(g, v))


function add_node!{K,E}(g::DiGraph{Node{K},E}, key::K; return_graph::Bool = false)
    index = get(g.indexof, key, 0)
    if index != 0
        v = Node(index,key)
        return return_graph? (g, v) : v
    end

    v = Node{K}(g, key)
    push!(g.nodes, v)
    push!(g.forward_ilist, E[])
    push!(g.backward_ilist, E[])
    g.indexof[key] = node_index(v)
    return_graph ? (g,v) : v
end

function add_edge!{V, E}(g::DiGraph{V ,E}, u::V, v::V, e::E)
    ui = node_index(u)
    vi = node_index(v)
    if !(e in g.forward_ilist[ui])
        push!(g.forward_ilist[ui], e)
    end
    if !(e in g.backward_ilist[vi])
        push!(g.backward_ilist[vi], e)
    end
    if !(e in g.edges)
        push!(g.edges, e)
    end
    e
end


function add_edge!{V,E}(g::DiGraph{V,E}, u::V, v::V)
    e = E(u, v)
    add_edge!(g, u, v, e)
end

function add_edge!{K}(g::DiGraph{Node{K}}, u_key::K, v_key::K)
    g, u = add_node!(g, u_key, return_graph = true)
    g, v = add_node!(g, v_key, return_graph = true)

    add_edge!(g, u, v)
end


"""
    aggregate_graph(g)

Convert an evolving graph `g` to a static graph by aggregate the edges to the same timestamp.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> eg = EvolvingGraph()
Directed EvolvingGraph 0 nodes, 0 static edges, 0 timestamps

julia> add_bunch_of_edges!(eg, [(1,2,3), (2,3,4), (1,2,1)])
Directed EvolvingGraph 3 nodes, 3 static edges, 3 timestamps

julia> aggregate_graph(eg)
DiGraph 3 nodes, 2 edges
```
"""
function aggregate_graph{V}(eg::AbstractEvolvingGraph{V})
    g = DiGraph{V,Edge{V}}()
    for e in edges(eg)
        add_edge!(g, node_key(source(e)), node_key(target(e)))
    end
    g
end



find_node{V}(g::DiGraph{V}, v::V) = v in g.nodes ? v : false
find_node(g::DiGraph, key) = get(g.indexof, key, false)


function adjacency_matrix(g::DiGraph)
    n = num_nodes(g)
    es = edges(g)
    A = zeros(Float64, n, n)
    for e in es
        i = node_index(source(e))
        j = node_index(target(e))
        A[i,j] = 1.
    end
    return A
end

function sparse_adjacency_matrix(g::DiGraph)
    es = edges(g)
    n = num_nodes(g)
    is = Int[]
    js = Int[]

    for e in es
        i = node_index(source(e))
        j = node_index(target(e))
        push!(is, i)
        push!(js, j)
    end
    vs = ones(Float64, length(is))
    return sparse(is, js, vs, n, n)
end
