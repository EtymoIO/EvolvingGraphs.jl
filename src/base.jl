
###########################################
#
# Root graph types
#
#############################################

#abstract type AbstractGraph{V, T, E}  end # V is node, T is time, and E is edge
#abstract type AbstractEvolvingGraph{V, T, E} <: AbstractGraph{V, T, E} end
#AbstractStaticGraph{V, E} = AbstractEvolvingGraph{V, 1, E}
abstract type AbstractGraph end
abstract type AbstractEvolvingGraph{V, T, E} <: AbstractGraph end
abstract type AbstractStaticGraph{V, E} <: AbstractGraph end


######################################
#
# Root path type
#
#######################################

abstract type AbstractPath end

##############################################
#
# Node types
#
##############################################

immutable Node{V}
    index::Int
    key::V
end
Node(v) = Node(0, v)
node_index(v::Node) = v.index
node_index(g::AbstractGraph, v::Node) = node_index(v)
node_key(v::Node) = v.key


==(v1::Node, v2::Node) = (v1.key == v2.key) && (v1.index == v2.index)
eltype{T}(::Node{T}) = T
make_node(g::AbstractGraph, key) = Node(num_nodes(g) + 1 , key)

function make_node(g::AbstractStaticGraph, key)
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
AttributeNode(index::Int, key) = AttributeNode(index, key, Dict())

node_index(v::AttributeNode) = v.index
node_key(v::AttributeNode) = v.key
attributes(v::AttributeNode) = v.attributes
attributes(v::AttributeNode, g::AbstractGraph) = v.attributes
eltype{T}(::AttributeNode{T}) = T
make_node(g::AbstractGraph, key, attr) =
   AttributeNode(num_nodes(g) + 1 , key, attr)


==(v1::AttributeNode, v2::AttributeNode) = (v1.key == v2.key &&
                                            v1.attributes == v2.attributes && v1.index == v2.index)


struct TimeNode{V<:Node,T} 
    node::V
    timestamp::T
end

node_key(v::TimeNode) = node_key(v.node)
timestamp(v::TimeNode) = v.timestamp
node_index(v::TimeNode) = node_index(v.node)
eltype{V,T}(::TimeNode{V,T}) = (V, T)

==(v1::TimeNode, v2::TimeNode) = (v1.node == v2.node &&
                                                               v1.timestamp== v2.timestamp)

NodeType{V} = Union{Node{V}, AttributeNode{V}, TimeNode{V}}
node_index(v::NodeType, g::AbstractGraph) = index(v)

NodeVector{V} = Vector{Node{V}}


##########################################
#
#  Edge types
#
##########################################


struct Edge{V}
    source::V
    target::V
end

source(e::Edge) = e.source
target(e::Edge) = e.target
==(e1::Edge, e2::Edge) = (e1.source == e2.source && e1.target == e2.target)
 rev(e::Edge) = Edge(e.target, e.source)


struct TimeEdge{V,T}
    source::V
    target::V
    timestamp::T
end

source(e::TimeEdge) = e.source
target(e::TimeEdge) = e.target
timestamp(e::TimeEdge) = e.timestamp
==(e1::TimeEdge, e2::TimeEdge) = (e1.source == e2.source &&
                                  e1.target == e2.target &&
                                  e1.timestamp == e2.timestamp)
rev(e::TimeEdge) = TimeEdge(e.target, e.source, e.timestamp)


immutable WeightedTimeEdge{V, T, W<:Real}
    source::V
    target::V
    weight::W
    timestamp::T
end

source(e::WeightedTimeEdge) = e.source
target(e::WeightedTimeEdge) = e.target
timestamp(e::WeightedTimeEdge) = e.timestamp
weight(e::WeightedTimeEdge) = e.weight
rev(e::WeightedTimeEdge) =
      WeightedTimeEdge(e.target, e.source, e.weight, e.timestamp)

EdgeType{V} = Union{Edge{V}, TimeEdge{V}, WeightedTimeEdge{V}}

"""
    has_node(e, v)

Return `true` if `v` is a node of the edge `e`.
"""
has_node{V}(e::EdgeType{V}, v::V) = (v == source(e) || v == target(e))
function has_node(e::EdgeType, v)
    v == source(e).key || v == target(e).key
end

#####################################
#
# Graph functions
#
######################################

is_directed(g::AbstractGraph) = g.is_directed
