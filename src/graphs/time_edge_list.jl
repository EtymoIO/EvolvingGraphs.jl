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

is_directed(g::TimeEdgeList) = g.is_directed
num_nodes(g::TimeEdgeList) = length(g.nodes)
nodes(g::TimeEdgeList) = g.nodes
edges(g::TimeEdgeList) = g.edges

function dim_times(g::TimeEdgeList)
    time = []
    for e in g.edges
        push!(time, edge_time(e))
    end
    time = unique(time)
    return length(time)
end

function add_node!(g::TimeEdgeList, v::Node)
    if v in g.nodes
        error("Duplicate node")
    else
        push!(g.nodes, v)
    end
    return v
end

add_node!(g::TimeEdgeList, key) = add_node!(g, make_node(g, key))


function add_edge!(g::TimeEdgeList, e::TimeEdge)
    if e in g.edges
        error("Duplicate edge")
    else
        push!(g.edges, e)
    end
    return e
end

add_edge!(g::TimeEdgeList, u::IndexNode, v::IndexNode, t) = add_edge!(g, make_edge(g, u, v, t))

function show(io::IO, a::TimeEdgeList)
    for v in nodes(a)
        print(io, "$(v) \n")
    end

    for e in edges(a)
        print(io, "$(e) \n")
    end
end
