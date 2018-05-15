g = IntAdjacencyList(4,3)
add_edge!(g, 1, 2, 1)
add_edge!(g, 2, 3, 1)
add_edge!(g, 1, 4, 2)

@test num_edges(g) == 3

@test num_timestamps(g) == 3

@test num_nodes(g) == 4

@test forward_neighbors(g, 1, 1) == [(2,1), (1,2)]

@test forward_neighbors(g, 2, 1) == [(3,1)]

@test adjacency_matrix(g, 1) ≈ [0 1 0 0; 0 0 1 0; 0 0 0 0; 0 0 0 0]

@test adjacency_matrix(g, 2) ≈ [0 0 0 1; 0 0 0 0; 0 0 0 0; 0 0 0 0]

@test full(sparse_adjacency_matrix(g, 1)) ≈ adjacency_matrix(g, 1)
@test full(sparse_adjacency_matrix(g, 2)) ≈ adjacency_matrix(g, 2)

add_edge!(g, 2, 4, 3)

@test num_edges(g) == 4

@test forward_neighbors(g, 2, 1) == [(3,1), (2,3)]

@test backward_neighbors(g, 4, 3) == [(4,2), (2,3)]

A = block_adjacency_matrix(g)

@test full(A)[1:4,1:4] ≈ adjacency_matrix(g, 1)
@test full(A)[5:8,5:8] ≈ adjacency_matrix(g, 2)
@test A[1, 5] ≈ 1.
@test A[2, 10] ≈ 0.5
@test A[8, 12] ≈ 1.
