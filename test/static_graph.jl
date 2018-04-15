g = digraph(String, Edge{String})

add_node!(g, "a")
add_node!(g, "b")
add_edge!(g, "a", "b")


@test length(nodes(g)) == 2
@test length(edges(g)) == 1
@test out_edges(g, "a") == [Edge("a", "b")]
@test in_edges(g, "b") == [Edge("a", "b")]

tnodes = [1, 2, 4]
tedges = [Edge(1, 2), Edge(2, 4)]

g2 = digraph(tnodes, tedges)
@test length(nodes(g2)) == 3
@test length(edges(g2)) == 2

g2 = evolving_graph(String, String)
add_edge!(g2, "a", "b", "t1")
add_edge!(g2, "b", "c", "t1")
add_edge!(g2, "c", "d", "t2")
add_edge!(g2, "a", "b", "t2")

g3 = aggregated_graph(g2)
display(g3)

A = matrix(g3, Int)
@test A[1,2] == 1
@test A[2,3] == 1
@test num_nodes(g3) == 4
@test num_edges(g3) == 3

# add a graph to an evolving graph
g = digraph(String, Edge{String})
add_node!(g, "1")
add_node!(g, "2")
add_edge!(g, "1", "2")
eg = evolving_graph(String, Int)
add_graph!(eg, g, 1)
@test length(nodes(eg)) == 2
@test length(edges(eg)) == 1

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
display(g2)
