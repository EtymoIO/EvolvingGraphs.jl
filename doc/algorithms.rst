Algorithms
==========

Katz Centrality
----------------

This is the generalization of the Katz centrality on static network on
a dynamic setting.

.. function:: katz_centrality(g [, alpha = 0.3, beta = 0.2; mode = :broadcast])

   compute the Katz centrality of the EvolvingGraph ``g``.
 
   :param g:      the input graph of type ``EvolvingGraph``.
   :param alpha:  controls the influence of long walks.
   :param beta:   controls the influence of walks happened long time ago.
   :param mode:   ``mode =:broadcast`` return the broadcast centrality
                  ranking; ``mode=:receive`` return the receive centrality
		  ranking; ``mode=:matrix`` return the communicability matrix.

   :returns: the centrality ranking tuple list.
