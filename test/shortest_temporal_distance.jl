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

p = shortest_temporal_path(g, 'a', 1, 'e', 3)
display(p)

@test shortest_temporal_distance(g, 'c', 2, 'a', 2) == Inf

g = int_evolving_graph(6, 3)
add_edge!(g, 1, 2, 1)
add_edge!(g, 1, 3, 2)
add_edge!(g, 4, 5, 2)
add_edge!(g, 2, 3, 3)
add_edge!(g, 5, 6, 3)

p = shortest_temporal_path(g, 1, 1, 3, 3)
@test length(p) - 1 == shortest_temporal_distance(g, 1, 1, 3, 3) 
display(p)
