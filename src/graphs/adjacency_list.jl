##############################################
#
# adjacency list
#
##############################################

type AdjacencyList <: AbstractEvolvingGraph
    is_directed::Bool
    nodes::Vector{Node}
    adjlist::Dict{Node,Vector{Node}}
    function AdjacencyList(;is_directed::Bool = true, 
                           nodes::Vector{Node} = Node[],
                           adjlist = Dict{Node, Vector{Node}}() )
        new(is_directed, nodes, adjlist)
    end
end
 
is_directed(g::AdjacencyList) = g.is_directed
num_nodes(g::AdjacencyList) = length(g.nodes)
vertices(g::AdjacencyList) = g.nodes

function show(io::IO, a::AdjacencyList)
    print(io, "Adjacency List \n")
    for k in keys(a.adjlist)
        for d in a.adjlist[k]
            print(io, "Edge $(k)->$(d)  \n")
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

function add_edge!(g::AdjacencyList, e::Edge)
    src = e.src
    dest = e.dest
    if !(src in g.nodes && dest in g.nodes)
        error("Node not in graph")
    end
    push!(g.adjlist[src], dest)    
    if !g.is_directed
        push!(g.adjlist[dest], src)
    end
end
 
out_neighbors(g::AdjacencyList, v::Node) = g.adjlist[v]
has_node(g::AdjacencyList, v::Node) = (v in g.nodes)
