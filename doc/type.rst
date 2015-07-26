Type System
===========

``AbstractGraph`` is at the apex of EvolvingGraphs' type hierarchy. 
It has two children: ``AbstractEvolvingGraph`` and ``AbstractStaticGraph``::

  abstract AbstractGraph{V, E, T}
  abstract AbstractEvolvingGraph{V, E, T} <: AbstractGraph{V, E, T}
  abstract AbstractStaticGraph{V, E} <: AbstractGraph{V, E}


``AbstractEvolvingGraph`` and ``AbstractStaticGraph`` are abstractions
of evolving graphs and static graphs
respectively. ``AbstractEvolvingGraph`` has four children:
``EvolvingGraph``, ``AttributeEvolvingGraph``, ``MatrixList`` and
``WeightedEvolvingGraph``. ``AbstractStaticGraph`` has two
children: ``TimeGraph`` and ``AggregatedGraph``.

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
  attributes(a)  #  Dict{Char,ASCIIString} with 1 entry: 'a' => "red"
 

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
``WeightedTimeEdge`` and ``AttributeTimeEdge``. 

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

The definition of ``AttributeTimeEdge`` is ::

  type AttributeTimeEdge{V, T, W}
    source::V
    target::V
    timestamp::T
    attributes::W
  end


The definition of ``WeightedTimeEdge`` is ::

  immutable WeightedTimeEdge{V, T, W<:Real}
    source::V
    target::V
    weight::W
    timestamp::T
  end


Graph Types
^^^^^^^^^^^

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

.. function:: out_neighbors(g, v)

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


EvolvingGraph
-------------

The most important graph type is ``EvolvingGraph``. Here is the
definition::

  type EvolvingGraph{V,T} <: AbstractEvolvingGraph{V, T}
    is_directed::Bool
    ilist::Vector{V}
    jlist::Vector{V}
    timestamps::Vector{T} 
  end


.. function:: evolving_graph(ils, jls, timestamps [, is_directed = true)
	    
   generate an ``EvolvingGraph`` type object from 3 vectors ``ils``,
   ``jls`` and ``timestamps`` such that ``ils[i] jls[i] timestamps[i]`` 
   represent an edge from ``ils[i]`` to ``jls[i]`` at time ``timestamps[i]``.
   The 3 vectors need to have the same length. For example::

     aa = ['a', 'b', 'c', 'c', 'a']
     bb = ['b', 'a', 'a', 'b', 'b']
     tt = ["t1", "t2", "t3", "t4", "t5"]
     gg = evolving_graph(aa, bb, tt, is_directed = false)

.. function:: evolving_graph(node_type, time_type [, is_directed = true])

   initialize an evolving graph with 0 nodes, 0 edges and 0 timestamps, 
   ``node_type`` is the type of nodes and ``time_type`` is the type of timestamps.

.. function:: evolving_graph([is_directed = true])
	      
   initialize an evolving graph with ``Integer`` nodes  and timestamps. 

.. function:: is_directed(g)
	      
   return ``true`` if graph ``g`` is a directed graph and ``false``
   otherwise.

.. function:: nodes(g)

   return a list of nodes of graph ``g``.

.. function:: num_nodes(g)

   return the number of nodes of graph ``g``.

.. function:: has_node(g, v, t)

   returns ``true`` of the node ``v`` at the timestamp ``t`` is in the 
   evolving graph ``g`` and ``false`` otherwise.

.. function:: edges(g [, timestamp])

   return a list of edges of graph ``g``. If ``timestamp`` is present,
   return the edge list at given ``timestamp``. 

.. function:: num_edges(g)

   return the number of edges of graph ``g``.

.. function:: timestamps(g)

   return the timestamps of graph ``g``.

.. function:: num_timestamps(g)
 
   return the number of timestamps of graph ``g``.

.. function:: add_edge!(g, te)
	      
   add a TimeEdge ``te`` to EvolvingGraph ``g``.

.. function:: add_edge!(g, v1, v2, t)

   add an edge (from ``v1`` to ``v2`` at timestamp ``t``) to EvolvingGraph ``g``.

.. function:: add_graph!(g, tg)
	      
   add a TimeGraph ``tg`` to EvolvingGraph ``g``.

.. function:: out_neighbors(g, v, t)

   returns all the outward neighbors of the node ``v`` at timestamp ``t`` in 
   the evolving graph ``g``. 

.. function:: matrix(g, t)
	      
   return an adjacency matrix representation of the EvolvingGraph
   ``g`` at timestamp ``t``.

.. function:: spmatrix(g, t)

   return a sparse adjacency matrix representation of the
   EvolvingGraph ``g`` at timestamp ``t``.


AttributeEvolvingGraph
----------------------

An ``AttributeEvolvingGraph`` is an evolving graph with attribute edges.
Here is the definition::

  type AttributeEvolvingGraph{V,T,W} <: AbstractEvolvingGraph{V,T,W}
    is_directed::Bool
    ilist::Vector{V}
    jlist::Vector{V}
    timestamps::Vector{T}
    attributesvec::Vector{W}
  end

The following functions are defined for ``AttributeEvolvingGraph``. 

.. function:: attribute_evolving_graph(node_type, time_type [, is_directed = true])

   initialize an evolving graph with 0 nodes, 0 edges and 0 timestamps, 
   where ``node_type`` is the type of nodes and ``time_type`` is the type
   of timestamps.

.. function:: attribute_evolving_graph([is_directed = true])

   initialize an evolving graph with ``Integer`` nodes and timestamps.

.. function:: is_directed(g)

   return ``true`` if graph ``g`` is a directed graph and ``false`` 
   otherwise.

.. function:: nodes(g)

   return a list of nodes of graph ``g``.

.. function:: has_node(g, v, t)

   returns ``true`` of the node ``v`` at the timestamp ``t`` is in the 
   evolving graph ``g`` and ``false`` otherwise.

.. function:: num_nodes(g)

   return the number of nodes of graph ``g``.

.. function:: edges(g [, timestamp])

   return a list of edges of graph ``g``. If ``timestamp`` is present, 
   return the edge list at given ``timestamp``.

.. function:: timestamps(g)

   return the timestamps of graph ``g``.

.. function:: num_timestamps(g)

   return the number of timestamps of graph ``g``.

.. function:: attributes(g, te)

   return the attributes of edge ``te`` on graph ``g``. 

.. function:: attributesvec(g)

   return all the attributes of graph ``g``.
	      
.. function:: add_edge!(g, te)

   add an AttributeTimeEdge ``te`` to AttributeEvolvingGraph ``g``.

.. function:: add_edge!(g, v1, v2, t, a)

   add an edge from ``v1`` to ``v2`` at timestamp ``t`` with attribute ``a`` 
   to the graph ``g``, where attribute is a dictionary.

.. function:: out_neighbors(g, v, t)

   returns all the outward neighbors of the node ``v`` at timestamp ``t`` in 
   the evolving graph ``g``. 

.. function:: matrix(g, t [, attr = None])

   return an adjacency matrix representation of graph ``g`` at timestamp ``t``. 
   If ``attr`` is present, return a weighted adjacency matrix where 
   the edge weight is given by the attribute ``attr``.

.. function:: spmatrix(g, t [, attr = None])

   return a sparse adjacency matrix representation of graph ``g`` at timestamp ``t``. 
   If ``attr`` is present, return a weighted adjacency matrix where 
   the edge weight is given by the attribute ``attr``.


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


WeightedEvolvingGraph
---------------------

.. note:: 
  
   ``WeightedEvolvingGraph`` is subject to change in the future version. 
   Please use ``AttributeEvolvingGraph`` instead. 

A ``WeightedEvolvingGraph`` is an evolving graph with weighted edges.
Here is the definition::

  type WeightedEvolvingGraph{V,T,W<:Real} <: AbstractEvolvingGraph{V,T,W}
     is_directed::Bool
     ilist::Vector{V}
     jlist::Vector{V}
     weights::Vector{W}
     timestamps::Vector{T} 
  end

The following functions are defined for ``WeightedEvolvingGraph``.

.. function:: weighted_evolving_graph(ils, jls, ws, timestamps [, is_directed = true])

   generate an ``WeightedEvolvingGraph`` from 4 vectors of same length:
   ``ils``, ``jls``, ``ws`` and ``timestamps`` such that 
   ``ils[i] jls[i] ws[i] timestamps[i]`` is an edge of weight ``ws[i]`` 
   from ``ils[i]`` to ``jls[i]`` at time ``timestamps[i]``. 

.. function:: weighted_evolving_graph(node_type, weight_type, time_type [, is_directed = true])

   initialize an evolving graph with ``node_type`` node, ``weight_type`` edge weight and 
   ``time_type`` timestamps.

.. function:: weighted_evolving_graph(;is_directed = true)

   initialize an evolving graph with ``Integer`` node and timestamps and 
   ``FloatingPoint`` edge weight.


.. function:: is_directed(g)

   return ``true`` if graph ``g`` is directed and ``false`` otherwise.

.. function:: nodes(g)

   return a list of nodes of graph ``g``.

.. function:: num_nodes(g)

   return the number of nodes of graph ``g``.

.. function:: edges(g)

   return a list of edges of graph ``g``.

.. function:: num_edges(g)    	      

   return the number of edges of graph ``g``.

.. function:: timestamps(g)

   return the timestamps of graph ``g``.

.. function:: num_timestamps(g)

   return the number of timestamps of graph ``g``.

.. function:: add_edge!(g, te)

   add a ``WeightedTimeEdge`` to graph ``g``.

.. function:: add_edge!(g, v1, v2, w, t)

   add an edge (of weight ``w`` from ``v1`` to ``v2`` at timestamp ``t``) to graph ``g``.
