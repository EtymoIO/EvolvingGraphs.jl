using EvolvingGraphs.Centrality

g = evolving_graph(String, String)
add_edge!(g, "a", "b", "t1")
add_edge!(g, "b", "c", "t1")
add_edge!(g, "c", "d", "t2")
add_edge!(g, "a", "b", "t2")
katz(g)
katz(g, sorted = false)
katz(g, 0.3, 0.2, mode = :receive)
katz(g, 0.3, 0.2, mode = :matrix)
katz(g, 0.2, 0.4, mode = :broadcast)
try
    katz(g, 0.3, 0.4, mode = :unknown)
catch ArgumentError
    println("unknown mode")
end
