testgraph = joinpath(Pkg.dir("EvolvingGraphs"), "data", "manunited_cont.graph")
graph = egreader(testgraph)
println("io passed test ...")
