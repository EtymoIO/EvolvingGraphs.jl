import LightGraphs

g = DiGraph{Node{String}, Edge{Node{String}}}()

add_node!(g, "a")
add_node!(g, "b")
add_edge!(g, "a", "b")


@test LightGraphs.nv(g) == 2
@test LightGraphs.ne(g) == 1
LightGraphs.add_edge!(g, Edge("b", "a"))
@test LightGraphs.ne(g) == 2
