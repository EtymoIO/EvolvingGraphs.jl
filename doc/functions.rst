Functions
=========

Basics
------

.. function:: is_directed(g)
   :noindex:
	      
   returns ``true`` if graph ``g`` is a directed graph and ``false``
   otherwise.

.. function:: nodes(g) 
   :noindex:	      

   returns a list of nodes of graph ``g``.

.. function:: num_nodes(g)
   :noindex:

   returns the number of nodes of graph ``g``.

.. function:: has_node(g, v, t)
   :noindex:

   returns ``true`` of the node ``v`` at the timestamp ``t`` is in the 
   evolving graph ``g`` and ``false`` otherwise.

.. function:: edges(g [, time])
   :noindex:

   returns a list of edges of graph ``g``. If ``time`` is present,
   return the edge list at given ``time``. 

.. function:: num_edges(g)
   :noindex:

   returns the number of edges of graph ``g``.

.. function:: timestamps(g)
   :noindex:	      

   returns the timestamps of graph ``g``.

.. function:: num_timestamps(g)
   :noindex: 

   returns the number of timestamps of graph ``g``.

.. function:: add_edge!(g, te)
   :noindex:
	      
   adds a TimeEdge ``te`` to EvolvingGraph ``g``.

.. function:: add_edge!(g, v1, v2, t)
   :noindex:

   adds an edge (from ``v1`` to ``v2`` at time ``t``) to an evolving graph ``g``.

.. function:: rm_edge!(g, v1, v2, t)
   :noindex:

   removes an edge from ``v1`` to ``v2`` at time ``t`` from an evolving graph ``g``.

.. function:: add_graph!(g, tg)
   :noindex:
	      
   adds a TimeGraph ``tg`` to EvolvingGraph ``g``.

.. function:: out_neighbors(g, v, t)
   :noindex:

   returns all the outward neighbors of the node ``v`` at timestamp ``t`` in 
   the evolving graph ``g``. 


Sorting
-------

.. function:: issorted(g)

   returns ``true`` if the timestamps of the evolving graph ``g``
   is sorted and ``false`` otherwise.

.. function:: sorttime!(g) 

   sorts the evolving graph ``g`` according to the order of timestamps.

.. function:: sorttime(g)

   returns a sorted evolving graph, leaving ``g`` unmodified.

Slicing
-------

.. function:: slice!(g, t_min, t_max)

   slices the evolving graph ``g`` between the timestamp ``t_min`` and
   ``t_max``.

Examples::

  g = evolving_graph(Int, String)
  add_edge!(g, 1, 2, "t1")
  add_edge!(g, 2, 3, "t2")
  add_edge!(g, 4, 2, "t2")
  add_edge!(g, 4, 2, "t1")
  add_edge!(g, 2, 1, "t3")
  slice!(g, "t1", "t3")

.. function:: slice(g, t_min, t_max)

   slices the evolving graph ``g`` between the timestamp ``t_min`` and 
   ``t_max``, leaving ``g`` unmodified.


Linear Algebra
--------------

.. function:: matrix(g, t [, attr])
   :noindex:
	      
   generates an adjacency matrix representation of the evolving graph ``g``
   at timestamp ``t``. If ``g`` has attributes, then ``matrix(g, t, attr)``
   generates a weighted adjacency matrix where the weight is determined 
   by the attribute ``attr``. 


.. function:: spmatrix(g, t [, attr])
   :noindex:   

   generates a sparse adjacency matrix representation of the evolving graph
   ``g`` at timestamp ``t``. 

Metrics
-------

.. function:: shortest_path(g, v1, v2 [, verbose = false)

   finds the shortest path from ``v1`` to ``v2`` on the time graph ``g``. 
   If ``verbose = true``, prints the current path at each search step. 

.. function:: shortest_distance(g, v1, v2)

   finds the shortest distance from ``v1`` to ``v2`` on the time graph ``g``. 
   returns ``Inf`` if there is no path from ``v1`` to ``v2``.

.. function:: shortest_temporal_path(g, (v1, t1), (v2, t2) [, verbose = false])

   finds the shortest temporal path from node ``v1`` at timestamp ``t1``
   to node ``v2`` at timestamp ``t2`` on the evolving graph ``g``. If ``verbose = true``,
   prints the current path at each search step.

.. function:: shortest_temporal_distance(g, (v1, t1), (v2, t2))

   finds the shortest temporal distance from node ``v1`` at timestamp ``t1`` 
   to node ``v2`` at timestamp ``t2`` on the evolving graph ``g``.
