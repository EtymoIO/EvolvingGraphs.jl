###################################
#
# AggregatedGraph
#
######################################

type AggregatedGraph{V} <: AbstractStaticGraph{V, Edge{V}}
    is_directed::Bool
    nodes::Vector{V}
    nedges::Int
    adjlist::Dict{V, Vector{V}}
end


@doc doc"""
`aggregated_graph(type [, is_directed = true])` initializes 
an aggregated graph. 
"""->
aggregated_graph{V}(::Type{V}; is_directed::Bool = true) = 
AggregatedGraph(is_directed, 
                Node{V}[],
                0,
                Dict{Node{V}, NodeVector{V}}())

aggregated_graph(::Type{AbstractString}; is_directed::Bool = true) = aggregated_graph(String, is_directed = is_directed)

@doc doc"""
`aggregated_graph(g)` converts an evolving graph `g` to 
the corresponding aggregated static graph. 
"""->
function aggregated_graph{V}(g::AbstractEvolvingGraph{V})
    ag = aggregated_graph(V, is_directed = is_directed(g))
    for e in edges(g)
        add_edge!(ag, e.source, e.target)
    end
    ag
end

@doc doc"""
`aggregated_graph(g)` converts a time graph `g` to the 
corresponding aggregated static graph.
"""->
aggregated_graph{V}(g::TimeGraph{V}) =  AggregatedGraph(is_directed(g),  
                                                        g.nodes, g.nedges, g.adjlist)

