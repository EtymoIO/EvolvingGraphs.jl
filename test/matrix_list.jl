g = EvolvingGraph{Node{Int}, Int}()
add_edge!(g, 1, 2, 2001)
add_edge!(g, 1, 3, 2001)
add_edge!(g, 4, 5, 2002)
add_edge!(g, 2, 3, 2002)
add_edge!(g, 5, 6, 2003)

ml = evolving_graph_to_matrices(g)
for (i,m) in enumerate(ml)
    println("Matrix $i")
    println(m)
end

A = sparse_adjacency_matrix(ml, 1)

@test A == sparse_adjacency_matrix(g, 2001)
