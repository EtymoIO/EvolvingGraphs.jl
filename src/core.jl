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

function make_node{V}(g::AbstractGraph{Node{V}}, key::V) 
    ns = nodes(g)
    keys = map(x -> x.key, ns)
    index = findfirst(keys, key)
    if index == 0 
        return Node(num_nodes(g)+1, key)
    else
        return ns[index]
    end        
end



type AttributeNode{V} 
    index::Int
    key::V
    attributes::Dict
end
AttributeNode{V}(index::Int, key::V) = AttributeNode(index, key, Dict())

index(v::AttributeNode) = v.index
attributes(v::AttributeNode) = v.attributes
attributes(v::AttributeNode, g::AbstractGraph) = v.attributes
==(v1::AttributeNode, v2::AttributeNode) = (v1.key == v2.key &&
                                            v1.attributes == v2.attributes && v1.index == v2.index)

function make_node{V}(g::AbstractGraph{AttributeNode{V}}, key::V) 
    ns = nodes(g)
    keys = map(x -> x.key, ns)
    index = findfirst(keys, key)
    if index == 0 
        return AttributeNode(num_nodes(g)+1, key)
    else
        return ns[index]
    end        
end


immutable TimeNode{V,T} 
    index::Int
    key::V
    time::T
end

key(v::TimeNode) = v.key
time(v::TimeNode) = v.time
index(v::TimeNode) = v.index
==(v1::TimeNode, v2::TimeNode) = (v1.key == v2.key && v1.time == v2.time 
                                  && v1.index == v2.index )


typealias NodeType Union(Node, AttributeNode, TimeNode)

index(v::NodeType, g::AbstractGraph) = index(v)


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
 
rev(e::Edge) = Edge(e.target, e.source)
 

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
rev(e::TimeEdge) = TimeEdge(e.target, e.source, e.time)


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

type AttributeTimeEdge{V, T} 
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

