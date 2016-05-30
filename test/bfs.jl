g = evolving_graph()

add_edge!(g, 1, 2, 1)
add_edge!(g, 1, 3, 2)
add_edge!(g, 2, 3, 3)

ns = breadth_first_visit(g, 2, 1)
nns = nodes(g)
@test (nns[2], 1) in ns
@test (nns[2], 3) in ns
@test (nns[3], 3) in ns
