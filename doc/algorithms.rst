Algorithms
==========

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
