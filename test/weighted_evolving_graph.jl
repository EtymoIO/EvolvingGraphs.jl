g = weighted_evolving_graph()
add_edge!(g, 1, 2, 2.3, 1)
add_edge!(g, 2, 3, 2.4, 2)
add_edge!(g, 1, 4, 1., 3)
@test num_nodes(g) == 4
@test num_edges(g) == 3
@test num_timestamps(g) == 3
