# root type

abstract AbstractEvolvingGraph{V, E, T}


##############################################
#
# Node types
#
##############################################

immutable Node{T}
    Key::T
end
 
key(v::Node) = v.key
==(v1::Node, v2::Node) = (v1.key == v2.key)
 
function show(io::IO, v::Node)
    print(io, "Node($(v.key))")
end

immutable IndexNode{T}
    index::Int
    key::T
end

node_index(v::IndexNode) = v.index
key(v::IndexNode) = v.key
==(v1::IndexNode, v2::IndexNode) = (v1.key == v2.key && v1.index == v2.index)

make_node(g::AbstractEvolvingGraph, key) = IndexNode(num_nodes(g)+1, key)

node_index(v::IndexNode, g::AbstractEvolvingGraph) = node_index(v)

function show(io::IO, v::IndexNode)
    print(io, "IndexNode($(v.key))")
end


immutable TimeNode{K,T}
    index::Int
    key::K
    time::T
end

key(v::TimeNode) = v.key
node_time(v::TimeNode) = v.time
node_index(v::TimeNode) = v.index
==(v1::TimeNode, v2::TimeNode) = (v1.key == v2.key && v1.time == v2.time)



function show(io::IO, v::TimeNode)
    print(io, "TimeNode($(v.key), $(v.time))")
end


##########################################
#
#  edge types
#
##########################################

immutable Edge
    source::Node
    target::Node        
end
 
Edge(src::Char, dest::Char) = Edge(Node(src), Node(dest))
 
source(e::Edge) = e.source
target(e::Edge) = e.target
==(e1::Edge, e2::Edge) = (e1.source == e2.source && e1.target == e2.target)
 
rev(e::Edge) = Edge(e.source, e.target)
 
function show(io::IO, e::Edge)
    print(io, "Edge $(e.source)->$(e.target)")
end
 

immutable TimeEdge{K,T}
    source::K
    target::K
    time::T
end

source(e::TimeEdge) = e.source
target(e::TimeEdge) = e.target
edge_time(e::TimeEdge) = e.time
source(e::TimeEdge, g::AbstractEvolvingGraph) = e.source
target(e::TimeEdge, g::AbstractEvolvingGraph) = e.target
edge_time(e::TimeEdge, g::AbstractEvolvingGraph) = e.time
==(e1::TimeEdge, e2::TimeEdge) = (e1.source == e2.source && 
                                  e1.target == e2.target &&
                                  e1.time == e2.time)

make_edge(g::AbstractEvolvingGraph, u::IndexNode, v::IndexNode, t) =
TimeEdge(u, v, t)

function show(io::IO, e::TimeEdge)
    print(io, "TimeEdge($(e.source)->$(e.target)) at time $(e.time)")
end
