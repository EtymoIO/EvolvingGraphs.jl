Functions
=========

Nodes and Edges
----------------

.. function:: node_key(v)
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

.. function:: forward_neighbors(g, v, t)
   :noindex:

   returns all the outward neighbors of the node ``v`` at timestamp ``t`` in
   the evolving graph ``g``.

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

.. function:: matrix(g, t [,T])
   :noindex:

   generates an adjacency matrix representation of evolving graph ``g`` at time ``t``,
   where ``T = Float64`` (by default) determines the element type of the matrix.


.. function:: spmatrix(g, t [, T])
   :noindex:

   generates a sparse adjacency matrix representation of evolving graph
   ``g`` at timestamp ``t``, where ```T = Float64`` (by default) determines the
   element type of the matrix.

.. function:: matrix_list(g)
   :noindex:

   converts an evolving graph ``g`` to a list of adjacency matrices represented by
   ``MatrixList``. Use ``matrices(g)`` to generate the matrix list. For example::

     g = random_evolving_graph(4,3)
     g2 = matrix_list(g)
     matrices(g2)

Metrics
-------

.. function:: shortest_path(g, v1, v2 [, verbose = false)

   finds the shortest path from ``v1`` to ``v2`` on the time graph ``g``.
   If ``verbose = true``, prints the current path at each search step.

.. function:: shortest_distance(g, v1, v2)

   finds the shortest distance from ``v1`` to ``v2`` on the time graph ``g``.
   returns ``Inf`` if there is no path from ``v1`` to ``v2``.

.. function:: shortest_temporal_path(g, v1, t1, v2, t2 [, verbose = false])

   finds the shortest temporal path from node ``v1`` at timestamp ``t1``
   to node ``v2`` at timestamp ``t2`` on the evolving graph ``g``. If ``verbose = true``,
   prints the current path at each search step.

.. function:: shortest_temporal_distance(g, v1, t1, v2, t2)

   finds the shortest temporal distance from node ``v1`` at timestamp ``t1``
   to node ``v2`` at timestamp ``t2`` on the evolving graph ``g``.

.. function:: temporal_efficiency(g, v1, t1, v2, t2)

   returns the temporal efficiency from node ``v1`` at timestamp ``t1``
   to node ``v2`` at timestamp ``t2`` on the evolving graph ``g``. Temporal
   efficiency is a measure how efficient information can pass from node
   ``v1`` to node ``v2``, ranging from 0 to 1.

.. function:: global_temporal_efficiency(g, t1, t2)

   returns the global temporal efficiency of the evolving graph ``g`` between
   timestamp ``t1`` and ``t2``. The global temporal efficiency is a measure
   of how well information flow between two given timestamps.


Connected Components
--------------------

.. function:: temporal_connected(g, v1, t1, v2, t2)

	      returns ``true`` if there is temporal path from ``v1`` at
	      timestamp ``t1`` to ``v2`` at timestamp ``t2`` and ``false``
	      otherwise.

.. function:: weak_connected(g, v1, v2)

	      returns ``true`` if there is a temporal path from ``v1``
	      to ``v2`` at any timestamps.

.. function:: weak_connected_components(g [, valuesonly = true])

	      finds the weakly connected components of an evolving
	      graph ``g``, i.e, each node in the set is weakly connected to all the
	      other nodes. If ``valuesonly = false``, returns a dictionary with the
	      starting of the search as dictionary key.


Katz Centrality
----------------

This is the generalization of the static graph case Katz centrality.


.. function:: katz_centrality(g [, alpha = 0.3, sorted = true])

   compute the broadcast vector of a given evolving graph ``g``.


.. function:: katz_centrality(g, alpha, beta [; mode = :broadcast])

   compute the Katz centrality of the EvolvingGraph ``g``.

   :param g:      the input graph of type ``EvolvingGraph``.
   :param alpha:  controls the influence of long walks.
   :param beta:   controls the influence of walks happened long time ago.
   :param mode:   ``mode =:broadcast`` return the broadcast centrality
                  ranking; ``mode=:receive`` return the receive centrality
		  ranking; ``mode=:matrix`` return the communicability matrix.

   :returns: the centrality ranking tuple list


Examples::

    julia> i = ['a', 'd', 'b', 'b', 'c', 'd', 'a'];
    julia> j = ['b', 'b', 'c', 'a', 'd', 'a', 'b'];
    julia> t = ["t1", "t1", "t1", "t2", "t2", "t3", "t3"];
    julia> eg2 = evolving_graph(i, j, t);

    julia> katz_centrality(eg2)
    4-element Array{Tuple{Char,Float64},1}:
    ('a',0.5402939325784528)
    ('d',0.5562977048819551)
    ('b',0.4869480249001121)
    ('c',0.40186683243066906)

    julia> katz_centrality(eg2, 0.2, 0.2, mode =:receive)
    4-element Array{Tuple{Char,Float64},1}:
    ('a',0.5488655577866868)
    ('d',0.275310701066823)
    ('b',0.9999999999999999)
    ('c',0.5002275748460789)


Random Evolving Graphs
----------------------

We generate a random time graph and random evolving graph according to
the Erdős–Rényi model, i.e, set an edge between each pair of nodes with
equal probability, independently of the other edges.

.. function:: random_time_graph(t, n [,p = 0.5, is_directed = true, has_self_loops = false)

    generate a random time graph with ``Integer`` nodes and time.

    :param t: the time of the time graph.
    :param n: the number of nodes.
    :param p: the probability with which to add each edge.
    :param is_directed: whether to generate directed time graph.
    :param has_self_loops: whether to include edges ``v -> v``.

    :returns: the time graph ``g``.


.. function:: random_evolving_graph(nv, nt [, p = 0.5, is_directed = true, has_self_loops = false)

    generate a random evolving graph with ``Integer`` nodes and timestamps.

    :param nv: the number of nodes.
    :param nt: the number of timestamps.
    :param p: the probability with which to add each edge.
    :param is_directed: whether to generate directed time graph.
    :param has_self_loops: whether to include edges ``v -> v``.

    :returns: the evolving graph ``g``.
