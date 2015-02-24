##############################################
#
# adjacency list
#
##############################################

type AdjacencyList <: AbstractEvolvingGraph
    is_directed::Bool
    nodes::Vector{Node}
    adjlist::Dict{Node, Vector{Node}}
    function AdjacencyList(;is_directed::Bool = true,
                           node::Vector{Node} = Node[],
                           adjlist = Dict{Node, Vector{Node}}() )
        new(is_directed, nodes, adjlist)
    end
end

is_directed(g::AdjacencyList) = g.is_directed
num_nodes(g::AdjacencyList) = length(g.nodes)
nodes(g::AdjacencyList) = g.nodes

function show(io::IO, a::AdjacencyList)
    print(io, "Adjacency List \n")
    for k in keys(a.adjlist)
        for d in a.adjlist[k]
            print(io, "Edge($(k)->$(d))")
        end
    end
end

function add_node!(g::AdjacencyList, v::Node)
    if v in g.nodes
        error("Duplicate node")
    else 
        push!(g.nodes, v)
        g.adjlist[v] = Node[]
    end
    return v
end


