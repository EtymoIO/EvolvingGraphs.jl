# root type

abstract AbstractEvolvingGraph{N, E}


##############################################
#
# Node types
#
##############################################

immutable Node{T}
    key::T
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

index(v::IndexNode) = v.index
key(v::IndexNode) = v.key
==(v1::IndexNode, v2::IndexNode) = (v1.key == v2.key && v1.index == v2.index)

make_node{N<:IndexNode}(g::AbstractEvolvingGraph{N}, key) = V(num_nodes(g)+1, key)

function show(io::IO, v::IndexNode)
    print(io, "IndexNode($(v.key))")
end


immutable TimeNode{K,T}
    index::Int
    key::K
    time::T
end

node_key(v::TimeNode) = v.key
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
    src::Node
    dest::Node        
end
 
Edge(src::Char, dest::Char) = Edge(Node(src), Node(dest))
 
source(e::Edge) = e.src
destination(e::Edge) = e.dest
==(e1::Edge, e2::Edge) = (e1.src == e2.src && e1.dest == e2.dest)
 
rev(e::Edge) = Edge(e.dest, e.src)
 
function show(io::IO, e::Edge)
    print(io, "Edge $(e.src)->$(e.dest)")
end
 

immutable TimeEdge{K,T}
    index::Int
    source::K
    target::K
    time::T
end

source(e::TimeEdge) = e.source
target(e::TimeEdge) = e.target
edge_time(e::TimeEdge) = e.time
==(e1::TimeEdge, e2::TimeEdge) = (e1.source == e2.source && 
                                  e1.target == e2.target &&
                                  e1.time == e2.time)


function show(io::IO, e::TimeEdge)
    print(io, "TimeEdge($(e.source)->$(e.target)) at time $(e.time)")
end
