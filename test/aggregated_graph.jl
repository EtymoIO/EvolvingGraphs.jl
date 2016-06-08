

g2 = evolving_graph(ASCIIString, ASCIIString)
add_edge!(g2, "a", "b", "t1")
add_edge!(g2, "b", "c", "t1")
add_edge!(g2, "c", "d", "t2")
add_edge!(g2, "a", "b", "t2")

g3 = aggregated_graph(g2)
display(g3)

A = matrix(g3, Int)
@test A[1,2] == 1 
@test A[2,3] == 1
@test num_nodes(g3) == 4
@test num_edges(g3) == 3


