"""
    AbstractGraph{V,E}

Abstract supertype for all graph types, where `V` represents node type and `E` represents edge type.
"""
abstract type AbstractGraph{V,E} end

"""
    AbstractEvolvingGraph{V,E,T} <: AbstractGraph{V,E}

Abstract supertype for all evolving graph types, where `V` represents node type, `E` represents edge type, and `T` represents timestamp type.
"""
abstract type AbstractEvolvingGraph{V,E,T} <: AbstractGraph{V,E} end

"""
    AbstractStaticGraph{V,E} <: AbstractGraph{V,E}

Abstract supertype for all static graph types, where `V` represents node type and `E` represents edge etype.
"""
abstract type AbstractStaticGraph{V,E} <: AbstractGraph{V,E} end



"""
    AbstractNode{V}

Abstract supertype for all node types, where `V` is the type of the node key.
"""
abstract type AbstractNode{V} end

"""
    node_index(v)
    node_index(g::AbstractGraph, v)

Return the index of a node `v`.
"""
node_index(v::AbstractNode) = v.index
node_index(g::AbstractGraph, v::AbstractNode) = node_index(v)

"""
    node_key(v)

Return the key of a node `v`.
"""
node_key(v::AbstractNode) = v.key




"""
    Node(index, key)
    Node{V}(key)
    Node{V}(g, key)

Constructs a Node with node index `index` of type `V` and key value `key`.
If only `key` is given, set `index` to `0`. Node(g, key) constructs a new node in graph `g`, so index is equal to `num_nodes(g) + 1`.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> a = Node(1,"a")
Node(a)

julia> node_index(a)
1

julia> node_key(a)
"a"

julia> b = Node{String}("b")
Node(b)

julia> node_index(b)
0
```
"""
struct Node{V} <: AbstractNode{V}
    index::Int
    key::V
end
Node{V}(key::V) where {V} = Node(0, key)
Node{V}(g::AbstractGraph, key::V) where {V} = Node(num_nodes(g)+ 1, key)

==(v1::Node, v2::Node) = (v1.key == v2.key) && (v1.index == v2.index)
eltype{T}(::Node{T}) = T
eltype{T}(::Type{Node{T}}) = T

"""
    AttributeNode(index, key, attributes=Dict())
    AttributeNode{K, D_k, D_v}(key, attributes=Dict())
    AttributeNode{K, D_k, D_v}(g, key, attributes=Dict())

Construct an AttributeNode with index `index`, key value `key` and attributes `attributes`. If `index` is not given, set `index = 0`. `AttributeNode(g, key, attributes)` constructs a new AttributeNode for graph `g`, where `index = num_nodes(g) + 1`.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> a = AttributeNode(1, "a", Dict("a" => 12))
AttributeNode(a)

julia> node_key(a)
"a"

julia> node_index(a)
1

julia> node_attributes(a)
Dict{String,Int64} with 1 entry:
  "a" => 12
```
"""
mutable struct AttributeNode{V, D_k, D_v} <: AbstractNode{V}
    index::Int
    key::V
    attributes::Dict{D_k, D_v}
end
AttributeNode{V, D_k, D_v}(key::V, attributes=Dict{D_k, D_v}()) where V where D_k where D_v = AttributeNode(0, key, attributes)
AttributeNode{V}(key::V, attributes=Dict()) where V = AttributeNode(0, key, attributes)
AttributeNode{V, D_k, D_v}(g::AbstractGraph, key::V, attributes=Dict()) where V where D_k where D_v = AttributeNode(num_nodes(g) + 1 , key, attributes)
AttributeNode{KV}(g::AbstractGraph, key::KV, attributes=Dict()) = AttributeNode{KV, Any, Any}(g, key, attributes=attributes)


"""
    node_attributes(v)
    node_attributes(v, g::AbstractGraph)

Returns the attributes of AttributeNode `v`.
"""
node_attributes(v::AttributeNode) = v.attributes
node_attributes(v::AttributeNode, g::AbstractGraph) = v.attributes


eltype{T}(::AttributeNode{T}) = T
eltype{T}(::Type{AttributeNode{T}}) = T
==(v1::AttributeNode, v2::AttributeNode) = (v1.key == v2.key &&
                                            v1.attributes == v2.attributes && v1.index == v2.index)

"""
    TimeNode(index, key, timestamp)
    TimeNode{V,T}(key, timestamp)
    TimeNode{V,T}(g, key, timestamp)

Constructs a TimeNode at timestamp `timestamp`. `TimeNode(g, key, timestamp)` constructs a TimeNode in graph `g`.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> t = TimeNode(1, "t", 2018)
TimeNode(t, 2018)

julia> node_index(t)
1

julia> node_key(t)
"t"

julia> node_timestamp(t)
2018
```
"""
struct TimeNode{V,T} <: AbstractNode{V}
    index::Int
    key::V
    timestamp::T
end
TimeNode{V,T}(key, timestamp) where {V} where {T} = TimeNode(0, key, timestamp)
TimeNode{V,T}(g::AbstractGraph, key::V, timestamp::T) where {V} where {T} = TimeNode(num_active_nodes(g) + 1, key, timestamp)

"""
    node_timestamp(v)

Return the timestamp of TimeNode `v`.
"""
node_timestamp(v::TimeNode) = v.timestamp

eltype{V,T}(::TimeNode{V,T}) = (V, T)
==(v1::TimeNode, v2::TimeNode) = (v1.key == v2.key && v1.timestamp== v2.timestamp)



"""
    AbstractEdge{V}

Abstract supertype for all edge types, where `V` represents the type of the source and target nodes.
"""
abstract type AbstractEdge{V} end

"""
    source(e)

Return the source of edge `e`.
"""
source(e::AbstractEdge) = e.source

"""
    target(e)

Return the target of edge `e`.
"""
target(e::AbstractEdge) = e.target

"""
    edge_timestamp(e)

Return the timestamp of edge `e` if `e` is a time dependent edge, i.e., `TimeEdge` or `WeightedTimeEdge`.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> e1 = TimeEdge("A", "B", 1)
A->B at time 1

julia> edge_timestamp(e1)
1

julia> a = Edge(1, 2)
1->2

julia> edge_timestamp(a)
ERROR: type Edge has no field timestamp
[...]
```
"""
edge_timestamp(e::AbstractEdge) = e.timestamp

"""
    Edge(source, target)

Construct an Edge from a source node and a target node.
"""
struct Edge{V} <: AbstractEdge{V}
    source::V
    target::V
end

==(e1::Edge, e2::Edge) = (e1.source == e2.source && e1.target == e2.target)
eltype{V}(::Edge{V}) = V
eltype{V}(::Type{Edge{V}}) = V

"""
    TimeEdge(source, target, timestamp)

Construct a TimeEdge with source node `source`, target node `target` at time stamp `timestamp`.
"""
struct TimeEdge{V,T} <: AbstractEdge{V}
    source::V
    target::V
    timestamp::T
end

==(e1::TimeEdge, e2::TimeEdge) = (e1.source == e2.source &&
                                  e1.target == e2.target &&
                                  e1.timestamp == e2.timestamp)
eltype{V,T}(::TimeEdge{V,T}) = (V,T)
eltype{V,T}(::Type{TimeEdge{V,T}}) = (V,T)

"""
    WeightedTimeEdge(source, target, weight, timestamp)
    WeightedTimeEdge(source, target, timestamp)

Construct a WeightedTimeEdge. if `weight` is not given, set `weight = 1.0`.
"""
struct WeightedTimeEdge{V, T, W<:Real} <:AbstractEdge{V}
    source::V
    target::V
    weight::W
    timestamp::T
end
WeightedTimeEdge(source, target, timestamp) = WeightedTimeEdge(source, target, 1.0, timestamp)
==(e1::WeightedTimeEdge, e2::WeightedTimeEdge) =
                (e1.source == e2.source &&
                 e1.target == e2.target &&
                 e1.weight ≈ e2.weight &&
                 e1.timestamp == e2.timestamp)

eltype{V,T,W}(::WeightedTimeEdge{V,T,W}) = (V,T,W)
eltype{V,T,W}(::Type{WeightedTimeEdge{V,T,W}}) = (V,T,W)

"""
    edge_weight(e)

Returns the edge weight of a WeightedTimeEdge `e`.
"""
edge_weight(e::WeightedTimeEdge) = e.weight


"""
    edge_reverse(e)

Return the reverse of edge `e`, i.e., source is now target and target is now source.
"""
edge_reverse(e::Edge) = Edge(e.target, e.source)
edge_reverse(e::TimeEdge) = TimeEdge(e.target, e.source, e.timestamp)
edge_reverse(e::WeightedTimeEdge) =
      WeightedTimeEdge(e.target, e.source, e.weight, e.timestamp)


"""
    has_node(e, v)
    has_node(g, v)

In the first case, return `true` if `v` is a node of the edge `e`. In the second case, return `true` if graph `g` contains node `v` and `false` otherwise, where `v` can a node type object or a node key.
"""
has_node{V}(e::AbstractEdge{V}, v::V) = (v == source(e) || v == target(e))

"""
    has_active_node(g,v)
    has_active_node(g,key,t)

Return `true` if evolving graph `g` contains active node `v`
and `false` otherwise, where `v` is a TimeNode. Alternatively,
we can input node key `key` and timestamp `t` to check if `g`
contains the corresponding active node.
"""
function has_active_node end

"""
    AbstractPath

Abstract supertype for all path types.
"""
abstract type AbstractPath end


TimeOrTuple = Union{TimeNode,Tuple{Int,Int}}
"""
    TemporalPath()

Construct a TemporalPath, i.e., an array of TimeNode.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> p = TemporalPath()


julia> push!(p, TimeNode(1, "a", 2001))
 TimeNode(a, 2001)

julia> push!(p, TimeNode(1, "b", 2002))
TimeNode(a, 2001)->TimeNode(b, 2002)

julia> p
TimeNode(a, 2001)->TimeNode(b, 2002)

julia> append!(p,p)
TimeNode(a, 2001)->TimeNode(b, 2002)->TimeNode(a, 2001)->TimeNode(b, 2002)
```
"""
mutable struct TemporalPath{T<:TimeOrTuple} <: AbstractPath
    nodes::Vector{T}
end

TemporalPath() = TemporalPath(Union{TimeNode,Tuple{Int,Int}}[])
push!(t::TemporalPath, n::TimeOrTuple) = (push!(t.nodes, n);  t)
append!(t::TemporalPath, ns::Vector{TimeOrTuple}) = (append!(t.nodes, ns);  t)
append!(t::TemporalPath, t2::TemporalPath) = (append!(t, t2.nodes);  t)
deepcopy(t::TemporalPath) = TemporalPath(deepcopy(t.nodes))

length(p::TemporalPath) = length(p.nodes)
Base.start(P::TemporalPath) = 1
Base.next(p::TemporalPath, state) = (p.nodes[state], state+1)
Base.done(p::TemporalPath, state) = state > length(p.nodes)


==(p1::TemporalPath, p2::TemporalPath) = (p1.nodes == p2.nodes)



"""
    nodes(g)

Return the nodes of a graph `g`.
"""
function nodes end


"""
    num_nodes(g)
"""
function num_nodes end

"""
    active_nodes(g)

Return the active nodes of an evolving graph `g`.
"""
function active_nodes end


"""
    num_active_nodes(g)

Return the number of active nodes of evolving graph `g`.
"""
function num_active_nodes end


"""
    find_node(g, v)

Return node `v` if `v` is a node of graph `g`, otherwise return false. If `v` is a node key, return corresponding node.
"""
function find_node end

"""
    add_node!(g, v)

Add a node to graph `g`, where `v` can be either a node type object or a node key.
"""
function add_node! end

"""
    edges(g)
    edges(g, t)

Return all the edges of graph `g`. If timestamp `t` is given, returns all the edges at timestamp `t`.
"""
function edges end


"""
    num_edges(g)

Return the number of edges of graph `g`.
"""
function num_edges end

"""
    add_edge!(g, v1, v2, t; weight = 1.0)

Add an edge from `v1` to `v2` at timestamp `t` to evolving graph `g`. By default edge weight `weight` is equal to `1.0`.
"""
function add_edge! end


"""
    add_bunch_of_edges!(g, ebunch)

Add a bunch of edges to graph `g` where `ebunch` is an array of edges.
Each edge in `ebunch` is of form `(source, target, timestamp)` or
`(source, target, timestamp, weight)`.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> g = EvolvingGraph()
Directed EvolvingGraph 0 nodes, 0 static edges, 0 timestamps

julia> add_bunch_of_edges!(g, [(1,2,2001), (2,3,2001), (3,1,2002), (2,3,2004)])
Directed EvolvingGraph 3 nodes, 4 static edges, 3 timestamps

julia> timestamps(g)
4-element Array{Int64,1}:
 2001
 2001
 2002
 2004
```
"""
function add_bunch_of_edges! end

"""
    is_directed(g)

Determine if a graph `g` is a directed graph.
"""
function is_directed end


"""
    timestamps(g)

Return the timestamps of graph `g`.
"""
function timestamps end

"""
    unique_timestamps(g)

Return the unique timestamps of graph `g`.
"""
function unique_timestamps end

"""
    num_timestamps(g)

Return the number of timestamps of graph `g`.
"""
function num_timestamps end


"""
    forward_neighbors(g, v)

Find the forward neighbors of a node `v` in graph `g`. If `g` is an evolving graph, we define the forward neighbors of a TimeNode `v` to be a collection of forward neighbors at time stamp `node_timestamp(v)` and the same node key at later time stamps.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> g = evolving_graph_from_arrays([1,1,2],[2,3,3], [1,2,3])
Directed EvolvingGraph 3 nodes, 3 static edges, 3 timestamps

julia> n = active_nodes(g)[1]
TimeNode(1, 1)

julia> forward_neighbors(g,n)
2-element Array{EvolvingGraphs.TimeNode{Int64,Int64},1}:
 TimeNode(2, 1)
 TimeNode(1, 2)
```

# References:

1. Jiahao Chen and Weijian Zhang, The Right Way to Search Evolving Graphs, Proceedings of IPDPS 2016.
"""
function forward_neighbors end

"""
    backward_neighbors(g, v)

Find the backward neighbors of a node `v` in graph `g`. If `g` is an evolving graph, we define the backward neighbors of a TimeNode `v` to be a collection of backward neighbors at time stamp `node_timestamp(v)` and the same node key at earlier time stamps.

```jldoctest
julia> using EvolvingGraphs

julia> g = evolving_graph_from_arrays([1,1,2],[2,3,3], [1,2,3])
Directed EvolvingGraph 3 nodes, 3 static edges, 3 timestamps

julia> n = active_nodes(g)[2]
TimeNode(2, 1)

julia> backward_neighbors(g,n)
1-element Array{EvolvingGraphs.TimeNode{Int64,Int64},1}:
 TimeNode(1, 1)
```

# References:

1. Jiahao Chen and Weijian Zhang, The Right Way to Search Evolving Graphs, Proceedings of IPDPS 2016.
"""
function backward_neighbors end
