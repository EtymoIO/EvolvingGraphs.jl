g = EvolvingGraph()

add_edge!(g, 1, 2, 1)
add_edge!(g, 1, 3, 2)
add_edge!(g, 2, 3, 3)

ns = breadth_first_visit(g, 2, 1)
nns = nodes(g)
@test (nns[2], 1) in ns
@test (nns[2], 3) in ns
@test (nns[3], 3) in ns

g = IntAdjacencyList(4,3)

add_edge!(g, 1, 2, 1)
add_edge!(g, 1, 3, 2)
add_edge!(g, 2, 3, 3)
add_edge!(g, 4, 1, 1)
add_edge!(g, 4, 3, 2)
ns = breadth_first_visit(g, 1, 1)
@test (1,1) in ns
@test (3,2) in ns
@test (2,3) in ns
@test (3,3) in ns
@test !((4,2) in ns)
