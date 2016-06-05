
###########################################
#
# Root graph types
#
#############################################

abstract AbstractGraph{V, E, T}
abstract AbstractEvolvingGraph{V, E, T} <: AbstractGraph{V, E, T}
abstract AbstractStaticGraph{V, E} <: AbstractGraph{V, E}

######################################
#
# Root path type
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
Node(v) = Node(0, v) 
node_index(v::Node) = v.index
node_index{V}(g::AbstractGraph{V}, v::V) = node_index(v)

key(v::Node) = v.key
==(v1::Node, v2::Node) = (v1.key == v2.key) && (v1.index == v2.index)
eltype{T}(::Node{T}) = T
make_node{V <: Node}(g::AbstractGraph{V}, key) = V(num_nodes(g) + 1 , key)

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
AttributeNode{V}(index::Int, key::V) = AttributeNode(index, key, Dict())

node_index(v::AttributeNode) = v.index
key(v::AttributeNode) = v.key
attributes(v::AttributeNode) = v.attributes
attributes(v::AttributeNode, g::AbstractGraph) = v.attributes
eltype{T}(::AttributeNode{T}) = T
make_node{V <: AttributeNode}(g::AbstractGraph{V}, key, attr) = 
   V(num_nodes(g) + 1 , key, attr)


==(v1::AttributeNode, v2::AttributeNode) = (v1.key == v2.key &&
                                            v1.attributes == v2.attributes && v1.index == v2.index)


immutable TimeNode{V<:Node,T} 
    node::V
    timestamp::T
end

key(v::TimeNode) = key(v.node)
timestamp(v::TimeNode) = v.timestamp
node_index(v::TimeNode) = node_index(v.node)
eltype{V,T}(::TimeNode{V,T}) = (V, T)

==(v1::TimeNode, v2::TimeNode) = (v1.node == v2.node && 
                                                               v1.timestamp== v2.timestamp)

typealias NodeType{V}  Union{Node{V}, AttributeNode{V}, TimeNode{V}}
node_index(v::NodeType, g::AbstractGraph) = index(v)




##########################################
#
#  Edge types
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
    timestamp::T
end

source(e::TimeEdge) = e.source
target(e::TimeEdge) = e.target
timestamp(e::TimeEdge) = e.timestamp
source(e::TimeEdge, g::AbstractEvolvingGraph) = e.source
target(e::TimeEdge, g::AbstractEvolvingGraph) = e.target
timestamp(e::TimeEdge, g::AbstractEvolvingGraph) = e.timestamp
==(e1::TimeEdge, e2::TimeEdge) = (e1.source == e2.source && 
                                  e1.target == e2.target &&
                                  e1.timestamp == e2.timestamp)
rev(e::TimeEdge) = TimeEdge(e.target, e.source, e.timestamp)
make_edge{V, E<:TimeEdge, T}(g::AbstractGraph{V, E, T}, v1::V, v2::V, t::T) = 
    TimeEdge(v1, v2, t)


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

typealias EdgeType{V}  Union{Edge{V}, TimeEdge{V}, WeightedTimeEdge{V}}

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


#### Evolving Graph functions ####


#`undirected!(g)` turns a directed graph to an undirected graph. 
undirected!(g::AbstractEvolvingGraph) = ( g.is_directed = false ; g)


#`undirected(g)` turns a directed graph `g` to an undirected graph, leaving `g` unchanged.
undirected(g::AbstractEvolvingGraph) = undirected!(deepcopy(g))


#`has_node(g, v, t)` returns `true` if the node `v` at the timestamp `t` is 
#in the evolving graph `g` and `false` otherwise. 
function has_node(g::AbstractEvolvingGraph, v, t)
    p = findin(g.timestamps , [t])
    return (v in g.ilist[p]) || (v in g.jlist[p]) 
end


#`timestamps(g)` returns the timestamps of an evolving graph `g`.
function timestamps(g::AbstractEvolvingGraph) 
    ts = unique(g.timestamps)
    return sort(ts)
end

#`num_timestamps(g)` returns the number of timestamps of `g`, 
#where `g` is an evolving graph.
num_timestamps(g::AbstractEvolvingGraph) = length(timestamps(g))

#`nodes(g)` returns the nodes of an evolving graph `g`. 
nodes(g::AbstractEvolvingGraph) = union(g.ilist, g.jlist)
num_nodes(g::AbstractEvolvingGraph) = length(nodes(g))
