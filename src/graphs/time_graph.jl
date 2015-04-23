##################################
#
# TimeGraph
#
##################################

type TimeGraph{T} <: AbstractEvolvingGraph
    is_directed::Bool
    time::T
    nodes::Vector{Node}
    nedges::Int
    adjlist::Dict{Node, Vector{Node}}
end

time_graph{T}(time::T; is_directed::Bool = true) =
    TimeGraph{T}(is_directed, 
                 time::T,
                 Node[],
                 0,
                 Dict{Node, Vector{Node}}())


is_directed(g::TimeGraph) = g.is_directed

nodes(g::TimeGraph) = g.nodes
num_nodes(g::TimeGraph) = length(g.nodes)

num_edges(g::TimeGraph) = g.nedges

time(g::TimeGraph) = g.time


function add_node!(g::TimeGraph, v::Node)
    if v in g.nodes
        error("Duplicate node $(v)")
    else 
        push!(g.nodes, v)
        g.adjlist[v] = Node[]
    end
    return v
end

function add_edge!(g::TimeGraph, e::Edge)
    src = e.source
    dest = e.target
    if !(src in g.nodes && dest in g.nodes)
        error("$(src) or $(dest) not in $(g)")
    end
    push!(g.adjlist[src], dest)    
    if !g.is_directed
        push!(g.adjlist[dest], src)
    end
    g.nedges += 1
end
 
out_neighbors(g::TimeGraph, v::Node) = g.adjlist[v]
has_node(g::TimeGraph, v::Node) = (v in g.nodes)



    
