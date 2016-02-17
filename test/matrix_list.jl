g = random_evolving_graph(4,5)
g2 = MatrixList(g)
@test num_matrices(g2) == num_timestamps(g)
@test num_nodes(g2) == num_nodes(g)

g = evolving_graph(Int, AbstractString) 
add_edge!(g, 1, 2, "t1") 
add_edge!(g,  1, 3, "t2") 
add_edge!(g, 4, 5, "t2") 
add_edge!(g, 2, 3, "t3")
add_edge!(g, 5, 6, "t3")

g2 = MatrixList(g)
@test nodes(g2) == nodes(g)
@test timestamps(g2) == timestamps(g)
@test matrix(g2, 1) == matrix(g, "t1")

g = MatrixList()
@test isempty(g)
add_matrix!(g, speye(4))
@test isempty(g) == false
I = [1,2,1]
J = [1,2,4]
V = ones(3)
A = sparse(I,J,V, 4,4)
add_matrix!(g, A)
@test num_nodes(g) == 4
@test num_timestamps(g) == 2

g = int_matrix_list(3)
A1 = sparse([1], [2], [2], 3, 3)
A2 = sparse([1], [3], [3], 3, 3)
A3 = sparse([2], [3], [4], 3, 3)
add_matrix!(g, A1)
add_matrix!(g, A2)
add_matrix!(g, A3)
A = spmatrix(g)
@test g.nodelists[1] == [1, 2]
@test g.nodelists[2] == [1, 3]
@test spmatrix(g, 2) == A2
@test forward_neighbours(g, 1, 1) == [(1,1), (1,2), (2,1)]
@test forward_neighbours(g, 2, 2) == [(0,0)]
@test forward_neighbours(g, 3, 2) == [(3,2), (3,3)]
@test A[1:3, 1:3] == spmatrix(g, 1)
@test A[4:6, 4:6] == spmatrix(g, 2)
@test A[7:9, 7:9] == spmatrix(g, 3)
@test A[1:3, 4:6] == sparse([1], [1], [1], 3, 3)
@test A[1:3, 7:9] == sparse([2], [2], [1], 3, 3)
@test A[4:6, 7:9] == sparse([3], [3], [1], 3, 3)

g = evolving_graph(Int, AbstractString)
add_edge!(g, 1, 2, "t1")
add_edge!(g, 2, 3, "t2")
add_edge!(g, 4, 2, "t2")
add_edge!(g, 4, 2, "t1")
add_edge!(g, 2, 1, "t3")
g2 = int_matrix_list(g)
@test spmatrix(g, "t1") == spmatrix(g2, 1)
@test spmatrix(g, "t2") == spmatrix(g2, 2)
@test nodelists(g2)[1] == [1,3]
@test spmatrix(g2)[5:8, 5:8] == spmatrix(g, "t2")
@test spmatrix(g2)[1:4, 5:8] == sparse([2, 3], [2,3], [1,1], 4, 4)
