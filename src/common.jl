# root type
# V: node type
# T: time type
# W: weight type
abstract AbstractEvolvingGraph{V, T, W}


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
 

immutable IndexNode{T}
    index::Int
    key::T
end

index(v::IndexNode) = v.index
key(v::IndexNode) = v.key
==(v1::IndexNode, v2::IndexNode) = (v1.key == v2.key && v1.index == v2.index)

make_node(g::AbstractEvolvingGraph, key) = IndexNode(num_nodes(g)+1, key)

index(v::IndexNode, g::AbstractEvolvingGraph) = index(v)


immutable TimeNode{K,T}
    index::Int
    key::K
    time::T
end

key(v::TimeNode) = v.key
time(v::TimeNode) = v.time
index(v::TimeNode) = v.index
==(v1::TimeNode, v2::TimeNode) = (v1.key == v2.key && v1.time == v2.time)



##########################################
#
#  edge types
#
##########################################

immutable Edge{V}
    source::V
    target::V       
end
 
source(e::Edge) = e.source
target(e::Edge) = e.target
==(e1::Edge, e2::Edge) = (e1.source == e2.source && e1.target == e2.target)
 
rev(e::Edge) = Edge(e.source, e.target)
 

immutable TimeEdge{V,T}
    source::V
    target::V
    time::T
end

source(e::TimeEdge) = e.source
target(e::TimeEdge) = e.target
time(e::TimeEdge) = e.time
source(e::TimeEdge, g::AbstractEvolvingGraph) = e.source
target(e::TimeEdge, g::AbstractEvolvingGraph) = e.target
time(e::TimeEdge, g::AbstractEvolvingGraph) = e.time
==(e1::TimeEdge, e2::TimeEdge) = (e1.source == e2.source && 
                                  e1.target == e2.target &&
                                  e1.time == e2.time)

immutable WeightedTimeEdge{V, T, W<:Real}
    source::V
    target::V
    weight::W
    time::T
end

source(e::WeightedTimeEdge) = e.source
target(e::WeightedTimeEdge) = e.target
time(e::WeightedTimeEdge) = e.time
weight(e::WeightedTimeEdge) = e.weight

typealias AttributeDict Dict{UTF8String, Any}

type ExTimeEdge{V, T}
    source::V
    target::V
    time::T
    attributes::AttributeDict
end

ExTimeEdge{V, T}(v1::V, v2::V, t::T) = ExTimeEdge(v1, v2, t, AttributeDict())

source(e::ExTimeEdge) = e.source
target(e::ExTimeEdge) = e.target
time(e::ExTimeEdge) = e.time
attributes(e::ExTimeEdge) = e.attributes
