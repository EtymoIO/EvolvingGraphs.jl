Graph Types
===========

TimeGraph
---------

The ``TimeGraph`` type represent a graph at given a time. The data is
stored as an adjacency list. Here is the definition::
  
  type TimeGraph{T} <: AbstractEvolvingGraph
    is_directed::Bool
    time::T
    nodes::Vector{Node}
    nedges::Int
    adjlist::Dict{Node, Vector{Node}}
  end

The following functions are defined on ``TimeGraph``.

.. function:: time_graph(t [, is_directed = true])

   initialize a ``TimeGraph`` at time ``t``.

.. function:: time(g)
	      
   return the time of the graph ``g``.	

.. function:: add_node!(g, v)
	      
    add a node ``v`` to ``TimeGraph`` g.

.. function:: add_edge!(g, e)

    add an edge to g.

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
   The 3 vectors need to have the same length.

.. function:: evolving_graph([is_directed = true])

   initialize an evolving graph with 0 nodes, 0 edges and 0 timestamps.

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

TimeTensor
----------

Sometimes it is convenient to work with matrices and that is why we
provide a ``TimeTensor`` type. Here is the definition::

  immutable TimeTensor{T, M} <: AbstractTensor
    is_directed::Bool
    times::Vector{T}
    matrices::Vector{Matrix{M}}
  end

The following functions are defined on ``TimeTensor`` 

.. function:: time_tensor(g)
	      
   convert ``g`` from ``EvolvingGraph`` to ``TimeTensor``.

.. function:: is_directed(g)
	      
   return ``true`` if graph ``g`` is a directed graph and ``false``
   otherwise.

.. function:: matrices(g)

   return a list of adjacency matrices in ``g``.

.. function:: num_matrices(g)

   return the number of adjacency matrices in ``g``.

.. function:: timestamps(g)

   return the time stamps of graph ``g``.

.. function:: num_timestamps(g)
 
   return the number of time stamps of graph ``g``.


SparseTimeTensor
----------------

Here is the definition of ``SparseTimeTensor``::

  type SparseTimeTensor{T} <: AbstractTensor
    is_directed::Bool
    times::Vector{T}
    matrices::Vector{SparseMatrixCSC}
  end

Note the only difference from ``TimeTensor`` is that ``matrices`` are
stored as a vector of sparse matrices.
