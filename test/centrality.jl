# test Katz centrality

g = build_evolving_graph()
katz_centrality(g)
katz_centrality(g, mode = :receive)
katz_centrality(g, mode = :matrix)
