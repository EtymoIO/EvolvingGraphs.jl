#####################################
#
# root graph type
#
######################################

abstract AbstractGraph{V, E, T}
abstract AbstractEvolvingGraph{V, E, T} <: AbstractGraph{V, E, T}
abstract AbstractStaticGraph{V, E} <: AbstractGraph{V, E}

######################################
#
# root path type
#
#######################################

abstract AbstractPath

##############################################
#
# Node types
#
##############################################

immutable Node{V}
    index::Int
    key::V
end
 
index(v::Node) = v.index
key(v::Node) = v.key
==(v1::Node, v2::Node) = (v1.key == v2.key && v1.index == v2.index)
make_node(g::AbstractGraph, key) 

immutable AttributeNode{V}
    index::Int
    key::V
    attributes::Dict
    
    AttributeNode{V}(i::Int, key::V) = new(i, key, Dict())
end

make_vertex{T}(g::AbstractGraph{AttributeNode{T}}, key::T) = AttributeNode(num_nodes(g) + 1, key) 
index(v::AttributeNode) = v.index
attributes(v::AttributeNode) = v.attributes
attributes(v::AttributeNode, g::AbstractGraph) = v.attributes


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
abstract AbstractEdge{V,T}


immutable Edge{V} <: AbstractEdge{V}
    source::V
    target::V       
end
 
source(e::Edge) = e.source
target(e::Edge) = e.target
==(e1::Edge, e2::Edge) = (e1.source == e2.source && e1.target == e2.target)
 
rev(e::Edge) = Edge(e.target, e.source)
 

immutable TimeEdge{V,T} <:AbstractEdge{V,T}
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

rev(e::TimeEdge) = TimeEdge(e.target, e.source, e.time)


immutable WeightedTimeEdge{V, T, W<:Real} <: AbstractEdge{V, T}
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

type AttributeTimeEdge{V, T} <: AbstractEdge{V, T}
    source::V
    target::V
    time::T
    attributes::Dict
end

AttributeTimeEdge{V, T}(v1::V, v2::V, t::T) = AttributeTimeEdge(v1, v2, t, AttributeDict())

source(e::AttributeTimeEdge) = e.source
target(e::AttributeTimeEdge) = e.target
time(e::AttributeTimeEdge) = e.time
attributes(e::AttributeTimeEdge) = e.attributes

==(e1::AttributeTimeEdge, e2::AttributeTimeEdge) = (e1.source == e2.source && 
                                                    e1.target == e2.target &&
                                                    e1.time == e2.time)

rev(e::AttributeTimeEdge) = AttributeTimeEdge(e.target, e.source, e.time, e.attributes)

