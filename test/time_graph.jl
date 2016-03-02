g = time_graph(AbstractString, 1)
@test timestamp(g) == 1
a = Node(1, "a")
b = Node(2, "b")
e1 = Edge(a, b)
add_node!(g, a)
add_node!(g, b)
add_node!(g, "c")
add_edge!(g, e1)
forward_neighbors(g, a)
has_node(g, a)
@test num_nodes(g) == 3
A = matrix(g, Int)
@test A[1,2] == 1
g2 = time_graph(Int, 2)
add_edge!(g2, 1, 2)
add_edge!(g2, 2, 1)
eg = evolving_graph(Int, Int)
add_graph!(eg, g2)
