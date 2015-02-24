# root type

abstract AbstractEvolvingGraph


##############################################
#
# Node types
#
##############################################

immutable Node{K,T}
    key::K
    time::T
end

node_key(v::Node) = v.key
node_time(v::Node) = v.time
==(v1::Node, v2::Node) = (v1.key == v2.key && v1.time == v2.time)

function show(io::IO, v::Node)
    print(io, "Node($(v.key), $(v.time))")
end


##########################################
#
#  edge types
#
##########################################

immutable Edge{K,T}
    source::K
    target::K
    time::T
end

source(e::Edge) = e.source
target(e::Edge) = e.target
edge_time(e::Edge) = e.time
==(e1::Edge, e2::Edge) = (e1.source == e2.source && 
                                  e1.target == e2.target &&
                                  e1.time == e2.time)


function show(io::IO, e::Edge)
    print(io, "Edge($(e.source)->$(e.target)) at time $(e.time)")
end
