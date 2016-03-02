g = int_evolving_graph(3,3)
add_edge!(g, 1, 2, 1)
add_edge!(g, 1, 3, 2)
add_edge!(g, 2, 3, 3)
add_edge!(g, 2, 1, 2)

@test forward_neighbors(g, (1, 1)) == [(2,1), (1,2)]
