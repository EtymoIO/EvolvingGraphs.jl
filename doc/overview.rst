Overview
========

Introduction
-------------

We model an evolving graph as a sequence of static graphs
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

Definitions
--------------

  Evolving graphs
                    An evolving graph :math:`G_n` is a sequence of static graphs 
                    :math:`G_n=\langle G^{[1]}, G^{[2]}, \ldots G^{[n]} \rangle` with
	            associated time labels :math:`t_1, t_2, \ldots t_n` respectively.
		    Each :math:`G^{[t]} = (V^{[t]}, E^{[t]})` represents a static graph
		    labeled by a time :math:`t`.

  Temporal node
                    A temporal node is a pair :math:`(v,t)`, where :math:`v \in V^{[t]}` is 
		    a node at a time :math:`t`.

  Active node
                    A temporal node :math:`(v,t)` is an active node if there exists at least
		    one edge :math:`e \in E^{[t]}` that connects :math:`v \in V^{[t]}` to 
		    another node :math:`w \in V^{[t]}`, :math:`w \ne v`. An inactive node
		    is a temporal node that is node an active node.

		    
  Temporal path
                    A temporal path of length :math:`m` on an evolving graph :math:`G_n`
		    from temporal node :math:`(v_1, t_1)` to temporal node :math:`(v_m, t_m)`
		    is a time-ordered sequence of active nodes, 
		    :math:`\langle (v_1, t_1), (v_2, t_2), \ldots, (v_m, t_m) \rangle`. Here, 
	            time ordering means that :math:`t_1 \leq t_2 \leq \cdots \leq t_m` and
		    :math:`v_i = v_j` iff :math:`t_i \ne t_j`.


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

