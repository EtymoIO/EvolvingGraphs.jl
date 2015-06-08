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
   ``t_max`` (not includes ``t_max``).

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
   ``t_max`` (not includes  ``t_max``), leaving ``g`` unmodified.
