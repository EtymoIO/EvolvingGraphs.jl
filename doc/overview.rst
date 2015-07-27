Overview
========

Introduction
-------------

We model an evolving graph as an ordered set of static graphs
:math:`{G_1, G_2, \ldots, G_n }`, where :math:`G_t=(V(t), E(t))` is a
snapshot of the evolving graph at timestamp :math:`t`. :ref:`fig_eg3t`
shows an evolving graph with 3 timestamps. We say a node :math:`v` at
timestamp :math:`t`, denoted by :math:`(v,t)`, is *active* at timestamp
:math:`t` if it is connected to at least another node at timestamp
:math:`t`. For example, the nodes
:math:`(A,t_1),(B,t_1),(A,t_2),(C,t_2),(B,t_3),(C,t_3)` are active in
the evolving graph of :ref:`fig_eg3t`.

.. _fig_eg3t:
   
.. figure:: eg3t.png
   :align: center

   Figure 1

We define the *temporal path* :math:`p((v_i,t_1), (v_j,t_n))` between
node :math:`v_i` at timestamp :math:`t_1` and node :math:`v_j` at
timestamp :math:`t_n` to be an ordered set of active nodes
:math:`(v_i,t_1), (v_{i+1}, t_2),\ldots, (v_j,t_n)` such that
:math:`t_1 \leq t_2 \leq \ldots \leq t_n` and 
:math:`((v_h,t_k),(v_{h+1}, t_{k+1})) \in E(t_k)` if :math:`t_k = t_{k+1}`, 
otherwise we have :math:`v_h = v_{h+1}`. A *shortest temporal path* is a 
temporal path with the least number of unique nodes. 

In **EvolvingGraphs**, we could do::

  julia> g = evolving_graph(Char, String)
  Directed EvolvingGraph (0 nodes, 0 edges, 0 timestamps)

  julia> add_edge!(g, 'A', 'B', "t_1")
  Directed EvolvingGraph (2 nodes, 1 edges, 1 timestamps)

  julia> add_edge!(g, 'A', 'C', "t_2")
  Directed EvolvingGraph (3 nodes, 2 edges, 2 timestamps)

  julia> add_edge!(g, 'B', 'C', "t_3")
  Directed EvolvingGraph (3 nodes, 3 edges, 3 timestamps)

  julia> shortest_temporal_path(g, ('A', "t_1"), ('C',"t_3"))
  Temporal Path (3 walks) ('A',"t_1")->('A',"t_2")->('C',"t_2")->('C',"t_3")


Main Features
------------------

Here are the main features:

* A variety of data types for working with evolving graphs.

  - TimeEdge
  - WeightedTimeEdge
  - TimeGraph
  - EvolvingGraph     
  - WeightedEvolvingGraph
  - MatrixList
  - AttributeEvolvingGraph

* a collection of evolving graph algorithms.

  - Katz centrality
  - random evolving graph
  - more algorithms are being implemented

* io 

  - read/write the Evolving Graph Exchange Format file.

* All data structures and algorithms are implemented in *Julia*.

