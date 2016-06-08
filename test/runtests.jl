using EvolvingGraphs
using Base.Test

tests = [
         "core",
         "time_graph",
         "evolving_graph",
         "centrality",
         "random_graph",
         "io",
         "aggregated_graph",
         "int_evolving_graph",
         "matrix_list",
         "incidence_matrix",
         "bfs",
         "sort_slice",
         "shortest_distance",
         "shortest_temporal_distance",
         "temporal_efficiency",
         "components"
         ]

for t in tests
    tp = joinpath(Pkg.dir("EvolvingGraphs"), "test", "$(t).jl")
    println("running $(tp) ...")
    include(tp)
end
