##################################
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

time_graph{T}(::Type{String}, timestamp::T; is_directed::Bool = true) = time_graph(ASCIIString, timestamp, is_directed = is_directed)


@doc doc"""
`time(g)` returns the time of a time graph `g`.
"""->
timestamp(g::TimeGraph) = g.timestamp
