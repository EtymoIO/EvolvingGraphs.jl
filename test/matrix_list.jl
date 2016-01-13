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
