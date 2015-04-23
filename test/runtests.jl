using EvolvingGraphs
using Base.Test

tests = ["show",    
         "graphs",
         "io",
         "time_graph"
         ]

for t in tests
    tp = joinpath(Pkg.dir("EvolvingGraphs"), "test", "$(t).jl")
    println("running $(tp) ...")
    include(tp)
end
