Functions
=========

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
