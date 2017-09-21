g = digraph(String, Edge{String})

add_node!(g, "a")
add_node!(g, "b")
add_edge!(g, "a", "b")


@test length(nodes(g)) == 2
@test length(edges(g)) == 1
@test out_edges(g, "a") == [Edge("a", "b")]
@test in_edges(g, "b") == [Edge("a", "b")]

nodes = [1, 2, 4]
edges = [Edge(1, 2), Edge(2, 4)]

g2 = digraph(nodes, edges)
@test length(nodes(g2)) == 3
@test length(edges(g2)) == 2
