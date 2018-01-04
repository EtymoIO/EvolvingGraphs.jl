# test Katz centrality

g = evolving_graph(String, String)
add_edge!(g, "a", "b", "t1")
add_edge!(g, "b", "c", "t1")
add_edge!(g, "c", "d", "t2")
add_edge!(g, "a", "b", "t2")
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
