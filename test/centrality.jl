# test Katz centrality

g = build_evolving_graph()
katz_centrality(g)
katz_centrality(g, 0.3, 0.2, mode = :receive)
katz_centrality(g, 0.3, 0.2, mode = :matrix)
