g = EvolvingGraph()

add_edge!(g, 1, 2, 1)
add_edge!(g, 1, 3, 2)
add_edge!(g, 2, 3, 3)

l = depth_first_impl(g, 2, 1, 3, 3)
@test length(l) == 3 # number of nodes

g = IntAdjacencyList(4,3)

add_edge!(g, 1, 2, 1)
add_edge!(g, 1, 3, 2)
add_edge!(g, 2, 3, 3)
add_edge!(g, 4, 1, 1)
add_edge!(g, 4, 3, 2)
l = depth_first_impl(g, 4, 1, 3, 2)
@test length(l) == 3 # number of nodes
