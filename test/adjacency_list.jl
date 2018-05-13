g = IntAdjacencyList(4,3)
add_edge!(g, 1, 2, 1)
add_edge!(g, 2, 3, 1)
add_edge!(g, 1, 4, 2)

@test num_edges(g) == 3

@test num_timestamps(g) == 3

@test forward_neighbors(g, 1, 1) == [(2,1), (1,2)]

@test forward_neighbors(g, 2, 1) == [(3,1)]

add_edge!(g, 2, 4, 3)

@test num_edges(g) == 4

@test forward_neighbors(g, 2, 1) == [(3,1), (2,3)]
