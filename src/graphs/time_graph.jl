##################################
#
# TimeGraph
#
##################################

type TimeGraph{V, T} <: AbstractStaticGraph{V, Edge{V}}
    is_directed::Bool
    time::T
    nodes::Vector{V}
    nedges::Int
    adjlist::Dict{V, Vector{V}}
end

@doc doc"""
`time_graph(type, time [, is_directed = true])`
generates a time graph 

Input: 

    `type`: type of the nodes
    `time`: time of the graph
    `is_directed`: (optional) whether the graph is directed or not
"""->
time_graph{V,T}(::Type{V}, time::T; is_directed::Bool = true) =
    TimeGraph(is_directed, 
              time::T,
              Node{V}[],
              0,
              Dict{Node{V}, NodeVector{V}}())

time_graph{T}(::Type{String}, time::T; is_directed::Bool = true) = time_graph(ASCIIString, time, is_directed = is_directed)


@doc doc"""
`time(g)` returns the time of a time graph `g`.
"""->
time(g::TimeGraph) = g.time
