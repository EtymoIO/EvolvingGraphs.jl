Algorithms
==========

Katz Centrality
----------------

This is the generalization of the Katz centrality on static network on
a dynamic setting.


.. function:: katz_centrality(g [, alpha = 0.3])
 
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

