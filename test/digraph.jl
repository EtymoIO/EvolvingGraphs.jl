g = digraph(String, Edge{String})

add_node!(g, "a")
add_node!(g, "b")
add_edge!(g, "a", "b")


@test length(nodes(g)) == 2
@test length(edges(g)) == 1
@test out_edges(g, "a") == [Edge("a", "b")]
@test in_edges(g, "b") == [Edge("a", "b")]
