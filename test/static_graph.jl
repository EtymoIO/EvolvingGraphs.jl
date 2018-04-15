g = DiGraph{Node{String}, Edge{Node{String}}}()

add_node!(g, "a")
add_node!(g, "b")
add_edge!(g, "a", "b")


@test length(nodes(g)) == 2
@test length(edges(g)) == 1
@test out_edges(g, "a") == in_edges(g, "b")


g2 = EvolvingGraph{Node{String}, String}()
add_edge!(g2, "a", "b", "t1")
add_edge!(g2, "b", "c", "t1")
add_edge!(g2, "c", "d", "t2")
add_edge!(g2, "a", "b", "t2")

g3 = aggregate_graph(g2)
display(g3)

A = adjacency_matrix(g3)
@test A[1,2] == 1
@test A[2,3] == 1
@test num_nodes(g3) == 4
@test num_edges(g3) == 3

# add a graph to an evolving graph
g = DiGraph{Node{String}, Edge{Node{String}}}()
add_node!(g, "1")
add_node!(g, "2")
add_edge!(g, "1", "2")
eg = EvolvingGraph{Node{String}, Int}()
add_graph!(eg, g, 1)
@test length(nodes(eg)) == 2
@test length(edges(eg)) == 1
