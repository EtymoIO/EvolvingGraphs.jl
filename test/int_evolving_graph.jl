g = evolving_graph()
add_edge!(g, 1, 2, 1)
add_edge!(g, 2, 3, 1)
add_edge!(g, 1, 2, 2)
add_edge!(g, 1, 3, 2)
@test num_edges(g) == 4
@test num_nodes(g) == 3
@test num_edges(g, 1) == 2

@test length(weak_connected_components(g)) == 1

@test is_directed(g)
g1 = undirected(g)
@test !is_directed(g1)
@test num_edges(g1) == 8

@test length(edges(g)) == 4
