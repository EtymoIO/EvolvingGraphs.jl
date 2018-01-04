g2 = evolving_graph(String, Int)
add_edge!(g2, "a", "b", 1)
add_edge!(g2, "b", "c", 2)
add_edge!(g2, "c", "d", 2)
add_edge!(g2, "a", "b", 2)
add_edge!(g2, "b", "a", 3)

k =  global_temporal_efficiency(g2, 1, 2) 
