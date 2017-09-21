"""
    DiGraph{V, E, Inclist} <: AbstractStaticGraph{V, E}

Field:
    nodes: an indexed container of nodes
    edges: an indexed contrained of edges
    forward_ilist: forward incidence list
    backward_ilist: backword incidence list
    indexof: dictionary storing index for each node

DiGraph is a subtype of AbstractStaticGraph.
"""
type DiGraph{V, E, IncList} <: AbstractStaticGraph{V, E}
    nodes::Vector{V}
    edges::Vector{E}
    forward_ilist::IncList
    backward_ilist::IncList
    indexof::Dict{V,Int}
end


multivecs{T}(::Type{T}, n::Int) = [T[] for _ =1:n]

"""
    digraph(vs, es)

Generate a DiGraph type from a list of nodes `vs` and a list of edges `es`.
"""
function digraph{V, E}(vs::Vector{V}, es::Vector{E})
    n = length(vs)
    g = DiGraph(V[], E[], multivecs(E, n), multivecs(E, n), Dict{V, Int}())
    for v in vs
        add_node!(g, v)
    end
    for e in es
        add_edge!(g, e)
    end
    return g
end

"""
    digraph(V, E)

Initialize a DiGraph with node type `V` and edge type `E`.
"""
digraph{V, E}(::Type{V}, ::Type{E}) = DiGraph(V[], E[], [], [], Dict{V, Int}())
digraph() = digraph(Int, Edge{Int})


nodes(g::DiGraph) = g.nodes
num_nodes(g::DiGraph) = length(g.nodes)

edges(g::DiGraph) = g.edges
num_edges(g::DiGraph) = length(g.edges)

node_index{V}(g::DiGraph{V}, v::V) = try g.indexof[v] catch 0 end

"""
    out_edges(g, v)

Return the outward edges of node `v` in graph `g`.
"""
out_edges{V}(g::DiGraph{V}, v::V) = g.forward_ilist[node_index(g, v)]

"""
    out_degree(g, v)

Return the number of outward edges of node `v` in graph `g`.
"""
out_degree{V}(g::DiGraph{V}, v::V) = length(out_edges(g, v))


"""
    in_edges(g, v)

Return the inward edges of node `v` in graph `g`.
"""
in_edges{V}(g::DiGraph{V}, v::V) = g.backward_ilist[node_index(g, v)]

"""
    in_degree(g, v)

Return the number of inward edges of node `v` in graph `g`.
"""
in_degree{V}(g::DiGraph{V}, v::V) = length(in_edges(g, v))

"""
    add_node!(g, v)

Add node `v` to the graph `g`.
"""
function add_node!{V, E}(g::DiGraph{V, E}, v::V)
    push!(g.nodes, v)
    push!(g.forward_ilist, E[])
    push!(g.backward_ilist, E[])
    g.indexof[v] = length(g.nodes)
    v
end

"""
    add_edge!(g, u, v, e)

Add edge `e` with source node `u` and target node `v` to graph `g`.
"""
function add_edge!{V, E}(g::DiGraph{V ,E}, u::V, v::V, e::E)
    ui = node_index(g, u)::Int
    vi = node_index(g, v)::Int

    push!(g.forward_ilist[ui], e)
    push!(g.backward_ilist[vi], e)
    push!(g.edges, e)
    e
end

"""
    add_edge!(g, u, v)

Add an edge with source node `u` and target node `v` to graph `g`.
"""
function add_edge!{V,E}(g::DiGraph{V,E}, u::V, v::V)
    e = Edge(u, v)
    add_edge!(g, u, v, e)
end
