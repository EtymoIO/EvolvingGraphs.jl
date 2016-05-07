%##################################
#
# TimeGraph
#
##################################

type TimeGraph{V, T} <: AbstractStaticGraph{V, Edge{V}}
    is_directed::Bool
    timestamp::T
    nodes::Vector{V}
    nedges::Int
    adjlist::Dict{V, Vector{V}}
end

@doc doc"""
`time_graph(type, time [, is_directed = true])`
generates a time graph 

Input: 

    `type`: type of the nodes
    `timestamp`: timestamp of the graph
    `is_directed`: (optional) whether the graph is directed or not
"""->
time_graph{V,T}(::Type{V}, timestamp::T; is_directed::Bool = true) =
    TimeGraph(is_directed, 
              timestamp::T,
              Node{V}[],
              0,
              Dict{Node{V}, NodeVector{V}}())

time_graph{T}(::Type{AbstractString}, timestamp::T; is_directed::Bool = true) = time_graph(ASCIIString, timestamp, is_directed = is_directed)


@doc doc"""
`time(g)` returns the time of a time graph `g`.
"""->
timestamp(g::TimeGraph) = g.timestamp

#### Static Graph functions ####

#`nodes(g)` returns the nodes of a static graph `g`.
nodes(g::AbstractStaticGraph) = g.nodes


#`num_nodes(g)` returns the number of nodes of a static graph `g`.
num_nodes(g::AbstractStaticGraph) = length(g.nodes)


#`num_edges(g)` returns the number of edges of a static graph `g`.
num_edges(g::AbstractStaticGraph) = g.nedges


#`add_node!(g, v)` add a node `v` to a static graph `g`.
function add_node!{V<:NodeType}(g::AbstractStaticGraph{V}, v::V)
    if !(v in g.nodes)
        push!(g.nodes, v)
        g.adjlist[v] = V[]
    end
    v
end
add_node!(g::AbstractStaticGraph, v) = add_node!(g, make_node(g, v))


#`add_edge!(g, e)` adds an edge `e` to a static graph `g`. 
function add_edge!{V}(g::AbstractStaticGraph{V}, e::EdgeType{V})
    src = e.source
    dest = e.target
    if !(src in g.nodes)
        add_node!(g, src)
    end
    if !(dest in g.nodes)
        add_node!(g, dest)
    end

    if !(dest in g.adjlist[src])
        push!(g.adjlist[src], dest)    
        if !g.is_directed
            push!(g.adjlist[dest], src)
        end
        g.nedges += 1
    end
    return g
end

#`add_edge!(g, i, j)` adds an edge from node `i` to node `j` to a static graph `g`.
function add_edge!{V}(g::AbstractStaticGraph{V}, i::V, j::V)
    add_edge!(g, Edge(i,j))
end 

function add_edge!(g::AbstractStaticGraph, i, j) 
    n1 = add_node!(g, i)
    n2 = add_node!(g, j)
    add_edge!(g, n1, n2)
end


#`forward_neighbors(g, v)` returns a list of nodes that `v` points to on the
#static graph `g`.
forward_neighbors{V}(g::AbstractStaticGraph{V}, v::V) = g.adjlist[v]


#`has_node(g, v)` returns `true` if `v` is a node of the static graph `g` 
#and `false` otherwise.  
has_node{V}(g::AbstractStaticGraph{V}, v::V) = (v in g.nodes)


#`matrix(g, T)` generates an adjacency matrix of type T of 
#the static graph `g`. T = Bool by default.
function matrix{T<:Number}(g::AbstractStaticGraph, ::Type{T})
    ns = nodes(g)
    n = num_nodes(g)
    A = zeros(T, n, n)
    for (i,u) in enumerate(ns)
        for e in forward_neighbors(g, u)
            j = findfirst(ns, e)
            A[(j-1)*n + i] = one(T)
        end
    end
    A
end

matrix(g::AbstractStaticGraph) = matrix(g, Bool)
