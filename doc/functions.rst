Functions
=========

The following functions are defined for ``EvolvingGraph`` and 
``AttributeEvolvingGraph``.

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
	      
   generates an adjacency matrix representation of the evolving graph ``g``
   at timestamp ``t``. If ``g`` has attributes, then ``matrix(g, t, attr)``
   generates a weighted adjacency matrix where the weight is determined 
   by the attribute ``attr``. 


.. function:: spmatrix(g, t [, attr])

   generates a sparse adjacency matrix representation of the evolving graph
   ``g`` at timestamp ``t``. 

