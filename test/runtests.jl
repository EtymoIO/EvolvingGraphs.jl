using EvolvingGraphs
using Base.Test

tests = ["show",    
         "io",
         "nodes",
         "edges",
         "time_graph",
         "evolving_graph",
         "time_tensor",
         "sparse_time_tensor",
         "centrality",
         "random_graph"
         ]

for t in tests
    tp = joinpath(Pkg.dir("EvolvingGraphs"), "test", "$(t).jl")
    println("running $(tp) ...")
    include(tp)
end
