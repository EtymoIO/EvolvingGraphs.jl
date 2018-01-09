g = evolving_graph(Int, String, is_directed = false)
add_edge!(g, 2, 4, "t1")
add_edge!(g, 2, 5, "t1")
add_edge!(g, 2, 3, "t2")
add_edge!(g, 4, 5, "t2")
add_edge!(g, 1, 2, "t3")
add_edge!(g, 1, 4, "t3")
add_edge!(g, 2, 3, "t4")

components = weak_connected_components(g)
comps = weak_connected_components(g, false)

@test length(components) == 1
@test weak_connected(g, 5, 1)
@test !(weak_connected(g, 1, 5))

g2 = evolving_graph(Int, Int)
add_edge!(g2, 1, 2, 1)
add_edge!(g2, 1, 3, 2)
add_edge!(g2, 4, 5, 2)
add_edge!(g2, 2, 3, 3)
add_edge!(g2, 5, 6, 3)

@test length(weak_connected_components(g2)) == 2
