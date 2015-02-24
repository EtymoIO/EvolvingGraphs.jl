# root type

abstract AbstractEvolvingGraph{V, E, T}


##############################################
#
# Node types
#
##############################################

immutable TimeNode{T}
    index::Int
    key::T
    time::Real

    function TimeNode(index::Int, key::T, time::Real = 0)
        time >= 0 || error("time must be non-negative.")

        new(index, key, time)
    end
end

node_key(v::TimeNode) = v.key
node_index(v::TimeNode) = v.index
node_time(v::TimeNode) = v.time


##########################################
#
#  edge types
#
##########################################

immutable TimeEdge{T}
    source::T
    target::T
    time::Real
    function TimeEdge(source::T, target::T, time::Real = 0)
        time >= 0 || error("time must be non-negative")
        new(source, target, time)
    end
end

source(e::TimeEdge) = e.source
target(e::TimeEdge) = e.target
edge_time(e::TimeEdge) = e.time
source{V}(e::TimeEdge{V}, g::TimeEdge{V}) = e.source
target{V}(e::TimeEdge{V}, g::TimeEdge{V}) = e.target

function show(io::IO, e::TimeEdge)
    print(io, "edge $(e.source) -> $(e.target) at time $(e.time)")
end

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
                           adjlist::Dict{TimeNode, Vector{TimeNode}}() )
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

