using EvolvingGraphs
using Base.Test

tests = [
         "core",
         "time_graph",
         "evolving_graph",
         "centrality",
         "random_graph",
         "digraph",
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

t_passed = falses(length(tests))
for (i,t) in enumerate(tests)
    tp = joinpath(Pkg.dir("EvolvingGraphs"), "test", "$(t).jl")
    println("Testing $t ...")
    try
        include(tp)
        println("$t tests passed.\n")
        t_passed[i] = true
    catch
        println("$t tests failed!\n")
    end
end

println("##### Test Summary: #####")
for (i,t) in enumerate(tests)
    println(t_passed[i] ? "$t ✓" : "$t ✗")
end

@test all(t_passed)
