# Evolving graph represented by TimeEdgeList

type TimeEdgeList <: AbstractEvolvingGraph
    is_directed::Bool
    nodes::Vector{IndexNode}
    edges::Vector{TimeEdge}
    function TimeEdgeList(;is_directed::Bool = true, 
                          nodes::Vector{IndexNode} = IndexNode[],
                          edges::Vector{TimeEdge} = TimeEdge[])
        new(is_directed, nodes, edges)
    end
end


num_nodes(g::TimeEdgeList) = length(g.nodes)

add_node!(g::TimeEdgeList, v::IndexNode) = (push!(g.nodes, v); v)
add_node!(g::TimeEdgeList, key) = add_node!(g, make_node(g, key))

add_edge!(g::TimeEdgeList, e::TimeEdge) = (push!(g.edges, e); e)
add_edge!(g::TimeEdgeList, u::IndexNode, v::IndexNode, t) = (g, make_edge(g, u, v, t))
