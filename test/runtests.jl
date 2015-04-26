using EvolvingGraphs
using Base.Test

tests = ["show",    
         "io",
         "time_graph",
         "evolving_graph",
         "time_tensor",
         "sparse_time_tensor"
         ]

for t in tests
    tp = joinpath(Pkg.dir("EvolvingGraphs"), "test", "$(t).jl")
    println("running $(tp) ...")
    include(tp)
end
