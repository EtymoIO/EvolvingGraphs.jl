using EvolvingGraphs.Centrality

g = EvolvingGraph{Node{String}, Int}()
add_edge!(g, "a", "b", 1)
add_edge!(g, "b", "c", 1)
add_edge!(g, "c", "d", 2)
add_edge!(g, "a", "b", 2)
katz(g)
katz(g, 0.3, 0.2, mode = :receive)
katz(g, 0.2, 0.4, mode = :broadcast)
try
    katz(g, 0.3, 0.4, mode = :unknown)
catch ArgumentError
    println("unknown mode")
end
