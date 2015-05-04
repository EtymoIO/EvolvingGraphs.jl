# IntEvolvingGraph
a = [rand(1:10) for i = 1:10]
b = [rand(1:10) for i = 1:10]
c = [1:10;]
g = evolving_graph(a, b, c)
is_directed(g)
nodes(g)
num_nodes(g)
edges(g)
num_edges(g)
timestamps(g)
num_timestamps(g)

# EvolvingGraph
aa = ['a', 'b', 'c', 'c', 'a']
bb = ['b', 'a', 'a', 'b', 'b']
tt = ["t1", "t2", "t3", "t4", "t5"]
gg = evolving_graph(aa, bb, tt, is_directed = false)
nodes(gg)
@test num_nodes(gg) == 3
edges(gg)
edges(gg, "t1")
@test num_edges(gg) == 10
timestamps(gg)
@test num_timestamps(gg) == 5
reduce_timestamps!(gg)
@test num_timestamps(gg) == 3 

# convert to matrix
@test matrix(gg, "t2") == full(spmatrix(gg, "t2"))

g2 = evolving_graph(Int, Char, is_directed = true)
add_edge!(g2, 1, 2, 'a')
add_edge!(g2, 2, 3, 'b')
@test num_nodes(g2) == 3
@test num_edges(g2) == 2
@test num_timestamps(g2) == 2
