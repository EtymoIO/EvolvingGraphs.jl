##################################
#
# TimeGraph
#
##################################

type TimeGraph{V, T} <: AbstractStaticGraph
    is_directed::Bool
    time::T
    nodes::Vector{V}
    nedges::Int
    adjlist::Dict{V, Vector{V}}
end

@doc doc"""
`time_graph(type, time [, is_directed])`
generates a time graph 

Input: 

    `type`: type of the nodes
    `time`: time of the graph
    `is_directed`: (optional) whether the graph is directed or not
"""->
time_graph{V,T}(::Type{V}, time::T; is_directed::Bool = true) =
    TimeGraph{V,T}(is_directed, 
                   time::T,
                   V[],
                   0,
                   Dict{V, Vector{V}}())


is_directed(g::TimeGraph) = g.is_directed

@doc doc"""
`nodes(g)` returns the nodes of a time graph `g`.
"""->
nodes(g::TimeGraph) = g.nodes

@doc doc"""
`num_nodes(g)` returns the number of nodes of a time graph `g`.
"""->
num_nodes(g::TimeGraph) = length(g.nodes)

@doc doc"""
`num_edges(g)` returns the number of edges of a time graph `g`.
"""->
num_edges(g::TimeGraph) = g.nedges

@doc doc"""
`time(g)` returns the time of a time graph `g`.
"""->
time(g::TimeGraph) = g.time


@doc doc"""
`add_node!(g, v)` add a node `v` to a time graph `g`.
"""->
function add_node!{V}(g::TimeGraph, v::V)
    if !(v in g.nodes)
        push!(g.nodes, v)
        g.adjlist[v] = V[]
    end
    return v
end


@doc doc"""
`add_edge!(g, e)` adds an edge `e` to a time graph `g`. 
"""->
function add_edge!(g::TimeGraph, e::Edge)
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

@doc doc"""
`add_edge!(g, i, j)` adds an edge from node `i` to node `j` to a time graph
`g`.
"""->
function add_edge!{V}(g::TimeGraph, i::V, j::V)
    add_edge!(g, Edge(i,j))
end 


@doc doc"""
`out_neighbors(g, v)` returns a list of nodes that `v` points to on the
time graph `g`.
"""-> 
out_neighbors{V}(g::TimeGraph, v::V) = g.adjlist[v]


@doc doc"""
`has_node(g, v)` returns `true` if `v` is a node of the time graph `g` 
and `false` otherwise.  
"""->
has_node{V}(g::TimeGraph, v::V) = (v in g.nodes)



    
