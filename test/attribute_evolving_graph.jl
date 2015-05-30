# define AttributeTimeEdge
e1 = AttributeTimeEdge(1, 2, 1)
e2 = AttributeTimeEdge(2, 1, 1)
e3 = AttributeTimeEdge(2, 3, 2)
e3.attributes["a"] = 1
e3.attributes["b"] = 2

g = attribute_evolving_graph(Int, Int)

add_edge!(g, e1)
add_edge!(g, e2)
add_edge!(g, e3)

