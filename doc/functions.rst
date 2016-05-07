Functions
=========

Nodes and Edges
----------------

.. function:: key(v)
   :noindex:

   returns the key of a node ``v``. 

.. function:: node_index(v)
   :noindex:
 
   returns the index of a node ``v``.

.. function:: timestamp(v)
   :noindex:

   returns the timestamp of an instance of ``TimeNode``. 

.. function:: source(e [, g])
   :noindex:
	    
   returns the source of the edge ``e``, where ``g`` is a graph.

.. function:: target(e [, g])
   :noindex:	      

   returns the target of the edge ``e``, where ``g`` is a graph.

.. function:: timestamp(e)
   :noindex:	      

   returns the timestamp of an edge ``e`` if ``e`` is of type ``TimeEdge`` or 
   ``WeightedTimeEdge``.

.. function:: weight(e)
   :noindex:
	      
   returns the weight of an edge ``e`` if ``e`` is of type ``WeightedTimeEdge``.


Graphs
------

.. function:: is_directed(g)
   :noindex:
	      
   returns ``true`` if graph ``g`` is a directed graph and ``false``
   otherwise.

.. function:: undirected!(g)

   turns a directed evolving graph to an undirected evolving graph.

.. function:: undirected(g)

   turns a directed evolving graph ``g`` to an undirected evolving graph and 
   leaving ``g`` unmodified. 

.. function:: nodes(g) 
   :noindex:	      

   returns a list of nodes of graph ``g``.

.. function:: num_nodes(g)
   :noindex:

   returns the number of nodes of graph ``g``.

.. function:: has_node(g, v, t)
   :noindex:

   returns ``true`` if the node ``v`` at the timestamp ``t`` is in the 
   evolving graph ``g`` and ``false`` otherwise.


.. function:: has_edge(g, v1, v2, t) 

   returns ``true`` if there is an edge from ``v1`` to ``v2`` at time ``t``
   in the evolving graph ``g`` and ``false`` otherwise.


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


.. function:: add_edge!(g, v1, v2, t)
   :noindex:

   adds an edge (from ``v1`` to ``v2`` at time ``t``) to an evolving graph ``g``.

.. function:: add_edge!(g, [v1,...], [v2,...], t [, attr])

   adds all the edges from the first set ``[v1,...]`` to second set ``[v2...]``	  
   at timestamp ``t`. The dictionary ``attr`` is used to specify the graph
   attributes, if ``g`` is an attribute evolving graph.

.. function:: rm_edge!(g, v1, v2, t)
   :noindex:

   removes an edge from ``v1`` to ``v2`` at time ``t`` from an evolving graph ``g``.

.. function:: add_graph!(g, tg)
   :noindex:
	      
   adds a time graph ``tg`` to an evolving graph ``g``.

.. function:: forward_neighbors(g, (v, t))
   :noindex:

   returns all the outward neighbors of the node ``v`` at timestamp ``t`` in 
   the evolving graph ``g``. 

.. function:: attributes_values(g, attributeskey1, attributeskey2,...)

   returns the values of the given keys of the graph attributes.

.. function:: aggregated_graph(type [, is_directed = true])

   initializes an aggregated graph, where ``type`` is the node type. 

.. function:: aggregated_graph(g)

   converts an evolving graph or time graph to an aggregated graph.


Sorting
-------

.. function:: issorted(g)

   returns ``true`` if the timestamps of the evolving graph ``g``
   are sorted and ``false`` otherwise.

.. function:: sorttime!(g) 

   sorts the evolving graph ``g`` so that the timestamps of ``g`` are 
   in ascending order.

.. function:: sorttime(g)

   returns a sorted evolving graph, leaving ``g`` unmodified.

Slicing
-------

.. function:: slice!(g, t_min, t_max)

   slices the evolving graph ``g`` between the timestamp ``t_min`` and
   ``t_max``.

Examples::

  g = evolving_graph(Int, AbstractString)
  add_edge!(g, 1, 2, "t1")
  add_edge!(g, 2, 3, "t2")
  add_edge!(g, 4, 2, "t2")
  add_edge!(g, 4, 2, "t1")
  add_edge!(g, 2, 1, "t3")
  slice!(g, "t1", "t3")

.. function:: slice(g, t_min, t_max)

   slices the evolving graph ``g`` between the timestamp ``t_min`` and 
   ``t_max``, leaving ``g`` unmodified.


.. function:: slice!(g, [node1, node2, ...])

   slices the evolving graph ``g`` according to the given nodes, so that 
   the modified ``g`` is constructed by the given nodes only.

.. function:: slice(g, [node1, node2, ...])

   slices the evolving graph ``g`` according to the given nodes, leaving 
   ``g`` unmodified.
	 

Linear Algebra
--------------

.. function:: matrix(g [,T])
   :noindex:

   generates an adjacency matrix representation of the static graph ``g``,
   where ``T = Bool`` (by default) determine the eltype of the matrix.
   

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

.. function:: matrix_list(g)
   :noindex:
   
   converts an evolving graph ``g`` to a list of adjacency matrices represented by 
   ``MatrixList``. Use ``matrices(g)`` to generate the matrix list. For example::

     g = random_evolving_graph(4,3)
     g2 = matrix_list(g)
     matrices(g2)
