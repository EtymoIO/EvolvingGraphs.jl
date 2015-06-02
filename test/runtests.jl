using EvolvingGraphs
using Base.Test

tests = [
         "data",
         "nodes",
         "edges",
         "time_graph",
         "evolving_graph",
         "weighted_evolving_graph",
         "attribute_evolving_graph",
         "centrality",
         "random_graph"
         ]

for t in tests
    tp = joinpath(Pkg.dir("EvolvingGraphs"), "test", "$(t).jl")
    println("running $(tp) ...")
    include(tp)
end
