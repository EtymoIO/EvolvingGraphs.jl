# test Katz centrality

g = random_evolving_graph(6, 4)
katz_centrality(g)
katz_centrality(g, sorted = false)
katz_centrality(g, 0.3, 0.2, mode = :receive)
katz_centrality(g, 0.3, 0.2, mode = :matrix)
katz_centrality(g, 0.2, 0.4, mode = :broadcast)
try 
    katz_centrality(g, 0.3, 0.4, mode = :unknown)
catch ArgumentError
    println("unknown mode")
end
