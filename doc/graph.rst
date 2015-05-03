Graph Types
===========

TimeGraph
---------

The ``TimeGraph`` type represent a graph at given a time. The data is
stored as an adjacency list. Here is the definition::
  
  type TimeGraph{V, T} <: AbstractEvolvingGraph
    is_directed::Bool
    time::T
    nodes::Vector{V}
    nedges::Int
    adjlist::Dict{V, Vector{V}}
  end

The following functions are defined on ``TimeGraph``.

.. function:: time_graph(type, t [, is_directed = true])

   initialize a ``TimeGraph`` at time ``t``, where ``type`` is the node type.

.. function:: time(g)
	      
   return the time of the graph ``g``.	

.. function:: add_node!(g, v)
	      
    add a node ``v`` to ``TimeGraph`` g.

.. function:: add_edge!(g, v1, v2)

    add an edge from ``v1`` to ``v2`` to g.

.. function:: out_neighbors(g, v)

    return the nodes that ``v`` points to on graph ``g``.	      

.. function:: has_node(g, v)

    return ``true`` if graph ``g`` has node ``v`` and ``false``
    otherwise.


EvolvingGraph
-------------

The most important graph type is ``EvolvingGraph``. Here is the
definition::

  type EvolvingGraph{V,T} <: AbstractEvolvingGraph{V, TimeEdge, T}
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

.. function:: evolving_graph(node_type, time_type, [, is_directed = true])

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

.. function:: edges(g [, time])

   return a list of edges of graph ``g``. If ``time`` is present,
   return edge list at given ``time``. 

.. function:: num_edges(g)

   return the number of edges of graph ``g``.

.. function:: timestamps(g)

   return the time stamps of graph ``g``.

.. function:: num_timestamps(g)
 
   return the number of time stamps of graph ``g``.

.. function:: reduce_timestamps!(g [,n = 2])
	      
   reduce the number of timestamps by emerging the graph with less
   than ``n`` edges to a neighbour graph.  

.. function:: add_edge!(g, te)
	      
   add a TimeEdge ``te`` to EvolvingGraph ``g``.

.. function:: add_graph!(g, tg)
	      
   add a TimeGraph ``tg`` to EvolvingGraph ``g``.

.. function:: matrix(g, t)
	      
   return an adjacency matrix representation of the EvolvingGraph
   ``g`` at time ``t``.

.. function:: spmatrix(g, t)

   return a sparse adjacency matrix representation of the
   EvolvingGraph ``g`` at time ``t``.

