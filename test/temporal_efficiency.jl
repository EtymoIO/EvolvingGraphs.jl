g1 = random_evolving_graph(5, 5, 0.1)
g2 = random_evolving_graph(5, 5, 0.6)

@test global_temporal_efficiency(g1, 1, 5) < global_temporal_efficiency(g2, 1, 5)
