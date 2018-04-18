import LightGraphs

g = DiGraph{Node{String}, Edge{Node{String}}}()

add_node!(g, "a")
add_node!(g, "b")
add_edge!(g, "a", "b")


@test LightGraphs.nv(g) == 2
@test LightGraphs.ne(g) == 1
e = Edge("b", "a")
@test LightGraphs.src(e) == source(e)
@test LightGraphs.dst(e) == target(e)

LightGraphs.add_edge!(g, e)
@test LightGraphs.ne(g) == 2
