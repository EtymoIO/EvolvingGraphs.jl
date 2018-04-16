g = EvolvingGraph{Node{String},String}()

add_edge!(g, "a", "b", "t1")
add_edge!(g, "b", "c", "t1")
add_edge!(g, "c", "d", "t2")
add_edge!(g, "a", "b", "t2")

egwrite(g, "test1.csv")
g = egread("test1.csv")
@test num_nodes(g) == 4
@test num_timestamps(g) == 2

rm("test1.csv")

# twitter data
twitterdata = joinpath(Pkg.dir("EvolvingGraphs"), "data", "manunited_cont.csv")
twitter = egread(twitterdata)
ns = nodes(twitter)
es = edges(twitter)
ts = timestamps(twitter)
