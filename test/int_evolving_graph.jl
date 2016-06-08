g = int_evolving_graph(3,3)
add_edge!(g, 1, 2, 1)
add_edge!(g, 1, 3, 2)
add_edge!(g, 2, 3, 3)
add_edge!(g, 2, 1, 2)

@test nodes(g) == [1,2,3]
@test num_nodes(g) == 3
@test forward_neighbors(g, (1, 1)) == [(2,1), (1,2)]

g = int_evolving_graph(4,3)
add_edge!(g, 1, 2, 1)
add_edge!(g, 1, 4, 3)
add_edge!(g, 2, 3, 3)
add_edge!(g, 2, 3, 2)
add_edge!(g, 3, 2, 2)
add_edge!(g, 3, 4, 2)
display(g)

@test forward_neighbors(g, 1, 1) == [(2,1), (1,3)]
@test forward_neighbors(g, 3, 1) == []
@test forward_neighbors(g, 2,2) ==[(3,2), (2, 3)]

@test has_edge(g, 1, 2, 1)
@test has_edge(g, 1, 4, 1) == false

g = evolving_graph()
add_edge!(g, 1, 2, 1)
add_edge!(g, 1, 3, 1)
add_edge!(g, 1, 4, 2)
add_edge!(g, 1, 2, 2)
add_edge!(g, 2, 1, 3)
add_edge!(g, 2, 3, 3)
add_edge!(g, 1, 2, 1)
g = int_evolving_graph(g)
