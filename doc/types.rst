Type System
===========

Nodes and Edges
---------------

There are three node types: ``Node``, ``IndexNode`` and
``TimeNode``. The definition of ``Node`` is::

  immutable Node{T}
    Key::T
  end
 
The definition of ``IndexNode`` is::

  immutable IndexNode{T}
    index::Int
    key::T
  end

The definition of ``TimeNode`` is::

  immutable TimeNode{K,T}
    index::Int
    key::K
    time::T
  end

.. function:: key(v)

   return the key of a node ``v``, where ``v`` could be ``Node``,
   ``IndexNode`` or ``TimeNode``. 

.. function:: node_index(v)
	   
   return the index of a node ``v``. ``node_index`` is defined for 
   ``IndexNode`` and ``TimeNode``.


There are two edge types in the collection. The definition of ``Edge``
is::

  immutable Edge
    source::Node
    target::Node        
  end

The definition of ``TimeEdge`` is::

  immutable TimeEdge{K,T}
    source::K
    target::K
    time::T
  end

.. function:: source(e [, g])
	    
   return the source of the edge ``e``, where ``e`` could be either
   ``Edge`` or ``TimeEdge`` and ``g`` is a graph.


.. function:: target(e [, g])

   return the target of the edge ``e``, where ``g`` is a graph.

.. function:: edge_time(e)

   return the time of a ``TimeEdge`` type ``e``.

Graphs
-------

The root of all graph type is::
  
  abstract AbstractEvolvingGraph{V, E, T}

where ``V`` is the node type, ``E`` is the edge type and ``T`` is the
time type. Here is the definition of ``EvolvingGraph``::

  type EvolvingGraph{V,T} <: AbstractEvolvingGraph{V, TimeEdge, T}
    is_directed::Bool
    ilist::Vector{V}
    jlist::Vector{V}
    timestamps::Vector{T} 
  end

The following functions are defined on ``EvolvingGraph``.

.. function:: is_directed(g)
	      
   return ``true`` if graph ``g`` is a directed graph and ``false``
   otherwise.

.. function:: nodes(g)

   return a list of nodes of graph ``g``.

.. function:: num_nodes(g)

   return the number of nodes of graph ``g``.

.. function:: edges(g)

   return a list of edges of graph ``g``.

.. function:: num_edges(g)

   return the number of edges of graph ``g``.

.. function:: timestamps(g)

   return the time stamps of graph ``g``.

.. function:: num_timestamps(g)
 
   return the number of time stamps of graph ``g``.


 
