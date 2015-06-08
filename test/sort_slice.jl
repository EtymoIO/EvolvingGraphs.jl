g = evolving_graph(Int, String)
add_edge!(g, 1, 2, "t1")
add_edge!(g, 2, 3, "t2")
add_edge!(g, 4, 2, "t2")
add_edge!(g, 4, 2, "t1")
add_edge!(g, 2, 1, "t3")

@test issorted(g) == false

g1 = sorttime(g)

@test issorted(g1) == true
@test num_timestamps(g1) == 3

slice!(g1, "t1", "t3")

@test num_timestamps(g1) == 2

p = sortperm(g.timestamps)

[@test e in edges(g) for e in edges(g1)]

