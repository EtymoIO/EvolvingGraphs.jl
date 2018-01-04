### evolving graphs with integer nodes and timestamps

g = evolving_graph()
add_edge!(g, 1, 2, 1)
add_edge!(g, 1, 3, 1)
add_edge!(g, 1, 4, 2)
add_edge!(g, 1, 2, 2)
add_edge!(g, 2, 1, 3)
add_edge!(g, 2, 3, 3)
add_edge!(g, 1, 2, 1)

@test is_directed(g)
ns = nodes(g)
@test Node(1, 1) in ns
@test num_nodes(g) == 4
@test num_edges(g) == 6
@test rand(1:3) in timestamps(g)
@test num_timestamps(g) == 3

g = evolving_graph(is_directed = false)
add_edge!(g, 1, 2, 1)
add_edge!(g, 1, 3, 1)
add_edge!(g, 1, 4, 2)
add_edge!(g, 1, 2, 2)
add_edge!(g, 2, 1, 3)
add_edge!(g, 2, 3, 3)
add_edge!(g, 1, 2, 1)
@test is_directed(g) == false
@test num_nodes(g) == 4
@test num_edges(g) == 12

#### general evolving graphs

aa = ['a', 'b', 'c', 'c', 'a']
bb = ['b', 'a', 'a', 'b', 'b']
tt = ["t1", "t2", "t3", "t4", "t5"]
gg = evolving_graph(aa, bb, tt, is_directed = false)
display(gg)
nodes(gg)
N, T = eltype(gg)
# @test forward_neighbors(gg, 'c', "t4") == [('b', "t4")]

@test num_nodes(gg) == 3
edges(gg)
edges(gg, "t1")
@test num_edges(gg) == 10
timestamps(gg)
@test num_timestamps(gg) == 5



# convert to matrix
@test matrix(gg, "t2") == full(spmatrix(gg, "t2"))

g2 = evolving_graph(Int, Char, is_directed = true)
add_edge!(g2, 1, 2, 'a')
add_edge!(g2, 2, 3, 'b')
@test num_nodes(g2) == 3
@test num_edges(g2) == 2
@test num_timestamps(g2) == 2

# remove edge
g = evolving_graph(Int, String)
add_edge!(g, 1, 2, "t1")
add_edge!(g, 2, 3, "t2")
add_edge!(g, 4, 2, "t2")
add_edge!(g, 4, 2, "t1")
add_edge!(g, 2, 1, "t3")
v = EvolvingGraphs.find_node(g, 1)
@test has_node(g, v, "t1")

@test num_edges(g) == 5

add_edge!(g, [1,2,4], [3,4], "t1")
n = num_edges(g)
@test is_directed(g)

forward_neighbors(g, 2, "t1")

wg = weighted_evolving_graph(String, Int, Int, is_directed = false)
add_edge!(wg, "a", "b", 1, 2)
add_edge!(wg, "b", "c", 1, 1)
add_edge!(wg, "a", "e", 2, 4)
add_edge!(wg, "e", "f", 3, 2)
@test num_edges(wg) == 8
display(wg)

@test matrix(wg, 1) == full(spmatrix(wg, 1))

wg = weighted_evolving_graph()
add_edge!(wg, 1, 2 ,1, 1)
add_edge!(wg, 2, 1, 2, 2)
