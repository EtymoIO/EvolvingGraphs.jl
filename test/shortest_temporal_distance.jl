g = evolving_graph(Char, Int, is_directed = false)
add_edge!(g, 'a', 'b', 1)
add_edge!(g, 'b', 'g', 1)
add_edge!(g, 'b', 'f', 1)
add_edge!(g, 'c', 'e', 2)
add_edge!(g, 'e', 'g', 2)
add_edge!(g, 'a', 'b', 2)
add_edge!(g, 'b', 'f', 2)
add_edge!(g, 'f', 'd', 2)
add_edge!(g, 'a', 'b', 3)
add_edge!(g, 'c', 'f', 3)
add_edge!(g, 'e', 'g', 3)
add_edge!(g, 'g', 'f', 3)

p = shortest_temporal_path(g, ('a', 1), ('e', 3))
@test p == TemporalPath([('a', 1), ('b', 1), ('g', 1), ('e', 3)])

@test shortest_temporal_distance(g, ('c', 2), ('a', 2)) == Inf
