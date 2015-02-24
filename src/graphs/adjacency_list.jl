##############################################
#
# adjacency list
#
##############################################

type AdjacencyList <: AbstractEvolvingGraph
    is_directed::Bool
    nodes::Vector{TimeNode}
    adjlist::Dict{TimeNode, Vector{TimeNode}}
    function AdjacencyList(;is_directed::Bool = true,
                           node::Vector{TimeNode} = TimeNode[],
                           adjlist = Dict{TimeNode, Vector{TimeNode}}() )
        new(is_directed, nodes, adjlist)
    end
end


function add_node!(g::AdjacencyList, v::TimeNode)
    if v in g.nodes
        error("Duplicate node")
    else 
        push!(g.nodes, v)
        g.adjlist[v] = TimeNode[]
    end
    return v
end


