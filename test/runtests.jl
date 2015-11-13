using EvolvingGraphs
using Base.Test
using Compat

tests = [
         "data",
         "core",
         "time_graph",
         "evolving_graph",
         "weighted_evolving_graph",
         "attribute_evolving_graph",
         "centrality",
         "random_graph",
         "sort_slice",
         "shortest_distance",
         "shortest_temporal_distance",
         "io",
         "temporal_efficiency",
         "components",
         "aggregated_graph",
         "int_evolving_graph",
         "matrix_list",
         "plot"
         ]

for t in tests
    tp = joinpath(Pkg.dir("EvolvingGraphs"), "test", "$(t).jl")
    println("running $(tp) ...")
    include(tp)
end
