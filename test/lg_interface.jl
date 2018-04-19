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

@test LightGraphs.outneighbors(g, "b") == [Node(1, "a")]
@test LightGraphs.inneighbors(g, "b") == [Node(1, "a")]

@test reverse(e) == Edge("a", "b")
@test LightGraphs.vertices(g) == [Node(1,"a"), Node(2,"b")]
@test LightGraphs.edgetype(g) == Edge{Node{String}}

## issue with package: not defined for StaticGraphs
@test_broken LightGraphs.is_directed(g) == is_directed(g) == true

@test LightGraphs.nv(LightGraphs.SimpleDiGraph(g)) == 2
