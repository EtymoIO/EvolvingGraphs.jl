using EvolvingGraphs
using Base.Test

tests = ["show",    
         "graphs"
         ]

for t in tests
    tp = joinpath(Pkg.dir("EvolvingGraphs"), "test", "$(t).jl")
    println("running $(tp) ...")
    include(tp)
end
