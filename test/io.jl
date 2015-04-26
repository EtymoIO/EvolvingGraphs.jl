testgraph = joinpath(Pkg.dir("EvolvingGraphs"), "data", "manunited_cont.graph")
graph = egreader(testgraph)
info = egreader(testgraph, true)

