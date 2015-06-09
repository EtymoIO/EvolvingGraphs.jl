# test evolving graph
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

slice!(g1, "t1", "t2")

@test num_timestamps(g1) == 2

p = sortperm(g.timestamps)

[@test e in edges(g) for e in edges(g1)]

# test attribute evolving graph

ag = attribute_evolving_graph(Int, Int)
add_edge!(ag, 1, 2, 1, @compat Dict("a" => 1.2))
add_edge!(ag, 2, 1, 4, @compat Dict("b" => 1.2, "a" => 0))
add_edge!(ag, 2, 3, 3, @compat Dict("a" => 3.4))
add_edge!(ag, 3, 2, 1, @compat Dict("a" => 2.5))

ag1 = sorttime(ag)


ag2 = slice(ag, 1, 1)

@test num_timestamps(ag2) == 1
@test ag2.timestamps[1] == 1 
@test ag2.timestamps[2] == 1
