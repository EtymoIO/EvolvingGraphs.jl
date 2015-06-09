# test Katz centrality

g = random_evolving_graph(6, 4)
katz_centrality(g)
katz_centrality(g, 0.3, 0.2, mode = :receive)
katz_centrality(g, 0.3, 0.2, mode = :matrix)
