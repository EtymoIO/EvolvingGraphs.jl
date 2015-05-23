##################################
#
# TimeGraph
#
##################################

type TimeGraph{V, T} <: AbstractEvolvingGraph{V, T}
    is_directed::Bool
    time::T
    nodes::Vector{V}
    nedges::Int
    adjlist::Dict{V, Vector{V}}
end

@doc doc"""
time_graph(type, time [, is_directed])
generate a graph of type TimeGraph 

Input: 

    `type`: type of the nodes
    `time`: time of the graph
    `is_directed`: (optional) the graph is directed or not
"""->
time_graph{V,T}(::Type{V}, time::T; is_directed::Bool = true) =
    TimeGraph{V,T}(is_directed, 
                   time::T,
                   V[],
                   0,
                   Dict{V, Vector{V}}())


is_directed(g::TimeGraph) = g.is_directed

nodes(g::TimeGraph) = g.nodes
num_nodes(g::TimeGraph) = length(g.nodes)

num_edges(g::TimeGraph) = g.nedges

time(g::TimeGraph) = g.time


function add_node!{V}(g::TimeGraph, v::V)
    if !(v in g.nodes)
        push!(g.nodes, v)
        g.adjlist[v] = V[]
    end
    return v
end

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

function add_edge!{V}(g::TimeGraph, i::V, j::V)
    add_edge!(g, Edge(i,j))
end 
 
out_neighbors{V}(g::TimeGraph, v::V) = g.adjlist[v]
has_node{V}(g::TimeGraph, v::V) = (v in g.nodes)



    
