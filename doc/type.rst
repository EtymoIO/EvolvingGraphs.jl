Type System
===========

``AbstractGraph`` is at the apex of EvolvingGraphs' type hierarchy.
It has two children: ``AbstractEvolvingGraph`` and ``AbstractStaticGraph``::

  abstract AbstractGraph{V, T, E}
  abstract AbstractEvolvingGraph{V, T, E} <: AbstractGraph{V, T, E}
  abstract AbstractStaticGraph{V, E} <: AbstractGraph{V, E}


``AbstractEvolvingGraph`` and ``AbstractStaticGraph`` are abstractions
of evolving graphs and static graphs
respectively. ``AbstractEvolvingGraph`` has three children:
``EvolvingGraph``, ``IntEvolvingGraph``, and
``MatrixList``. ``AbstractStaticGraph``
has two children: ``TimeGraph`` and ``AggregatedGraph``.

Before discussing the graph types, let us first look at the building
blocks of graphs: nodes and edges.

Nodes and Edges
^^^^^^^^^^^^^^^

Node Types
----------

``Node``, ``AttributeNode`` and ``TimeNode`` are designed for
different purposes. ``Node`` is constructed as::

  immutable Node{V}
    index::Int
    key::T
  end

Each node on a graph has an unique index and a key representation of
any Julia type. For example, it can be an integer, a character or a
string::

  julia> a = Node(1, "a")
  Node(a)

  julia> a = Node(1, 'a')
  Node(a)

  julia> a = Node(1, 3)
  Node(3)

  julia> index(a)
  1


``AttributeNode`` is a node with attributes. Here is the definition of
``AttributeNode``::

  type AttributeNode{V}
    index::Int
    key::V
    attributes::Dict
  end

We can initialize an instance of ``AttributeNode`` with just
``index`` and ``key`` and modify the values of ``attributes`` later::

  a = AttributeNode(1, 'a')
  attributes(a) = Dict('a' => "red")
  index(a)       # 1
  key(a)         # 'a'
  attributes(a)  #  Dict{Char,String} with 1 entry: 'a' => "red"


``TimeNode`` is used to represent a node at a specific timestamp.
(We will embed ``TimeNode`` to evolving graphs in the future.)
The definition of ``TimeNode`` is::

  immutable TimeNode{K,T}
    index::Int
    key::K
    timestamp::T
  end


Edge Types
----------

An edge is made of two nodes: a source node and a target node. In
EvolvingGraphs, there are four types of edges: ``Edge``, ``TimeEdge``,
and ``WeightedTimeEdge``.

The definition of ``Edge`` is::

  immutable Edge{V}
    source::V
    target::V
  end

The definition of ``TimeEdge`` is::

  immutable TimeEdge{K,T}
    source::K
    target::K
    timestamp::T
  end

The definition of ``WeightedTimeEdge`` is ::

  immutable WeightedTimeEdge{V, T, W<:Real}
    source::V
    target::V
    weight::W
    timestamp::T
  end


Static Graph Types
^^^^^^^^^^^^^^^^^^^^


TimeGraph
---------

``TimeGraph`` represents a graph at given a timestamp. The data is
stored as an adjacency list. Here is the definition::

  type TimeGraph{V, T} <: AbstractEvolvingGraph{V, T}
    is_directed::Bool
    timestamp::T
    nodes::Vector{V}
    nedges::Int
    adjlist::Dict{V, Vector{V}}
  end

The following functions are defined on ``TimeGraph``.

.. function:: time_graph(type, t [, is_directed = true])

   initialize a ``TimeGraph`` at timestamp ``t``, where ``type`` is the node type.

.. function:: timestamp(g)
   :noindex:

   return the timestamp of the graph ``g``.

.. function:: add_node!(g, v)

    add a node ``v`` to ``TimeGraph`` g.

.. function:: add_edge!(g, v1, v2)

    add an edge from ``v1`` to ``v2`` to g.

.. function:: forward_neighbors(g, v)

    return the nodes that ``v`` points to on graph ``g``.

.. function:: has_node(g, v)

    return ``true`` if graph ``g`` has node ``v`` and ``false``
    otherwise.

AggregatedGraph
---------------

``AggregatedGraph`` is a static graph ``g`` constructed by aggregating
an evolving graph, i.e., all the links between each pair of nodes are
flattened in a single edge. The definition of ``AggregatedGraph`` is::

  type AggregatedGraph{V} <: AbstractStaticGraph{V, Edge{V}}
    is_directed::Bool
    nodes::Vector{V}
    nedges::Int
    adjlist::Dict{V, Vector{V}}
  end

We can convert an evolving graph to an aggregated graph::

  julia> g = random_evolving_graph(4, 3)
  Directed IntEvolvingGraph (4 nodes, 19 edges, 3 timestamps)

  julia> aggregated_graph(g)
  Directed AggregatedGraph (4 nodes, 11 edges)

An aggregated graph can be initialized as ::

  julia> a = aggregated_graph(Int)
  Directed AggregatedGraph (0 nodes, 0 edges)

  julia> add_edge!(a, 1, 2)
  Directed AggregatedGraph (2 nodes, 1 edges)

Evolving Graph Types
^^^^^^^^^^^^^^^^^^^^^^^

EvolvingGraph
-------------

The most important graph type is ``EvolvingGraph``. Here is the
definition::

  type EvolvingGraph{V, T, E, I} <: AbstractEvolvingGraph{V, T, E}
    is_directed::Bool
    nodes::Vector{V}                                   # a vector of nodes
    edges::Vector{E}                                   # a vector of edges
    timestamps::Vector{T}                          # a vector of timestamps
    indexof::Dict{I, Int}                                # a dictionary storing index for each node
    activenodes::Vector{TimeNode{V,T}} # a vector of active nodes
  end


.. function:: evolving_graph(ils, jls, timestamps [, is_directed = true)

   Generate an evolving graph from three input vectors: ils, jls and
   timestamps, such that the ith entry `(ils[i], jls[i] and
   timestamps[i])` is an edge from `ils[i]` to `jls[i]` at timestamp
   `timestamp[i]`. For example::

     aa = ['a', 'b', 'c', 'c', 'a']
     bb = ['b', 'a', 'a', 'b', 'b']
     tt = ["t1", "t2", "t3", "t4", "t5"]
     gg = evolving_graph(aa, bb, tt, is_directed = false)

.. function:: evolving_graph(node_type, time_type [, is_directed = true])

   Initialize an evolving graph where the nodes are of type `node_type` and
   the timestamps are of type `time_type`.

.. function:: evolving_graph([is_directed = true])

   Initialize an evolving graph with integer nodes  and timestamps.

.. function:: weighted_evolving_graph(node_type, time_type, edge_weight_type [, is_directed = true])

   Initialize a weighted evolving graph where the nodes are of type `node_type`,
   timestamps are of type `time_type` and the edge weights are of type
   `edge_weight_type`.

.. function:: weighted_evolving_graph([is_directed = true])

   Initialize a weighted evolving graph with integer nodes, integer timestamps, and
   integer edge weight.

.. function:: is_directed(g)

   Return ``true`` if graph ``g`` is a directed graph and ``false``
   otherwise.

.. function:: nodes(g)

   Return the nodes of the evolving graph `g`.

.. function:: num_nodes(g)

   Return the number of nodes of graph ``g``.

.. function:: has_node(g, v, t)

   Return `true` if `(v,t)` is an active node of `g` and `false` otherwise.

.. function:: edges(g [, timestamp])

   Return a list of edges of graph ``g``. If ``timestamp`` is present,
   return the edge list at given ``timestamp``.

.. function:: num_edges(g)

   Return the number of edges of graph ``g``.

.. function:: timestamps(g)

   Return the timestamps of graph ``g``.

.. function:: num_timestamps(g)

   Return the number of timestamps of graph ``g``.

.. function:: add_edge!(g, te)

   Add a TimeEdge ``te`` to EvolvingGraph ``g``.

.. function:: add_edge!(g, v1, v2, t)

   Add an edge (from ``v1`` to ``v2`` at timestamp ``t``) to EvolvingGraph ``g``.

.. function:: forward_neighbors(g, v, t)

   Return all the outward neighbors of the node ``v`` at timestamp ``t`` in
   the evolving graph ``g``.

.. function:: matrix(g, t)

   Return an adjacency matrix representation of the EvolvingGraph
   ``g`` at timestamp ``t``.

.. function:: spmatrix(g, t)

   Return a sparse adjacency matrix representation of the
   EvolvingGraph ``g`` at timestamp ``t``.


MatrixList
-------------

A ``MatrixList`` represents an evolving graph as a list of adjacency matrices.
It is defined as::

  type MatrixList{V,T} <: AbstractEvolvingGraph{V, Edge{V}, T}
    is_directed::Bool
    nodes::Vector{V}
    timestamps::Vector{T}
    matrices::Vector{Matrix{Bool}}
  end

The following functions are defined for ``MatrixList``.

.. function:: matrix_list(node_type, timestamp_type[, is_directed = true])

   initializes a ``MatrixList`` with ``node_type`` nodes and
   ``timestamp_type`` timestamps.

.. function:: matrix_list([is_directed = true])

   initializes a ``MatrixList`` with integer nodes and timestamps.

.. function:: matrices(g)

   generates a list of adjacency matrices from ``MatrixList g``.

.. function:: matrix(g, t)

   generates an adjacency matrix from the ``t`` -th timestamp of ``g``

.. function:: matrix(g, i:j)

   generates a list of adjacency matrices from ``g`` ranging from the
   ``i`` -th timestamp to the ``j`` -th timestamp.

IntEvolvingGraph
----------------

An ``IntEvolvingGraph`` is an evolving graph with integer nodes and
timestamps. It is implemented as adjacency lists::

  type IntEvolvingGraph <: AbstractEvolvingGraph
    is_directed::Bool
    nodes::UnitRange{Int}
    timestamps::Vector{Int}
    nnodes::Int      # number of nodes
    nedges::Int      # number of static edges
    forward_adjlist::Vector{Vector{Int}}
    backward_adjlist::Vector{Vector{Int}}
  end

``IntEvolvingGraph`` can be initialized using the function ``int_evolving_graph``.
For example::

 julia> g = int_evolving_graph(3,4)
 Directed IntEvolvingGraph (3 nodes, 0 static edges, 4 timestamps)

 julia> add_edge!(g, 1, 2, 1)
 Directed IntEvolvingGraph (3 nodes, 1 static edges, 4 timestamps)

 julia> add_edge!(g, 2, 3, 2)
 Directed IntEvolvingGraph (3 nodes, 2 static edges, 4 timestamps)

 julia> add_edge!(g, 1, 3, 3)
 Directed IntEvolvingGraph (3 nodes, 3 static edges, 4 timestamps)

 julia> forward_neighbors(g, 1,1)
 2-element Array{Tuple{Int64,Int64},1}:
  (2,1)
  (1,3)
