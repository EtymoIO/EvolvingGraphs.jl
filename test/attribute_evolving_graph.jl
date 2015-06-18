# define AttributeTimeEdge
e1 = AttributeTimeEdge(1, 2, 1)
e1.attributes["a"] = 1.5
e2 = AttributeTimeEdge(2, 1, 1)
e2.attributes["a"] = 1.2
e3 = AttributeTimeEdge(2, 3, 2)
e3.attributes["a"] = 1
e3.attributes["b"] = 2

g = attribute_evolving_graph(Int, Int)

g2 = attribute_evolving_graph(is_directed = false)

add_edge!(g, e1)
add_edge!(g, e2)
add_edge!(g, e3)
add_edge!(g, 1, 3, 2, @compat Dict("b" => 1.3))

@test length(edges(g)) == 4

@test length(edges(g, 1)) == 2

ns = nodes(g)

A = matrix(g, 1)

B = matrix(g, 1, "a")

@test sum(B - A) == 0.7

@test full(spmatrix(g, 1, "a")) == matrix(g, 1, "a")

@test full(spmatrix(g, 1)) == matrix(g, 1)

b = [(2,1), (1,2)]

@test out_neighbors(g, 1, 1) == b
@test out_neighbors(g, 1, 2) == [(3,2)]

# remove edge
ag = attribute_evolving_graph(Int, Int, is_directed = false)
add_edge!(ag, 1, 2, 1, @compat Dict("a" => 1.2))
add_edge!(ag, 2, 1, 4, @compat Dict("b" => 1.2, "a" => 0))
add_edge!(ag, 2, 3, 3, @compat Dict("a" => 3.4))
add_edge!(ag, 3, 2, 1, @compat Dict("a" => 2.5))
add_edge!(ag, 4, 2, 2)

values = attributes_values(ag, "a")
@test length(values) == 4

@test num_edges(ag) == 10

rm_edge!(ag , 1, 2, 4)

@test num_edges(ag) == 8
@test !has_edge(ag, 1, 2, 4)
@test !has_edge(ag, 2, 1, 4)

dict = @compat Dict("hello" => 3)
add_edge!(ag, [1,2,3], [4,5], 1, dict)


