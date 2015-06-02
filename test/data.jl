# traffic data
trafficdata = joinpath(Pkg.dir("EvolvingGraphs"), "data", "traffic20141201.csv")
traffic = egread(trafficdata)
ns = nodes(traffic)
es = edges(traffic)
ts = timestamps(traffic)

# twitter data
twitterdata = joinpath(Pkg.dir("EvolvingGraphs"), "data", "manunited_cont.csv")
twitter = egread(twitterdata)
ns = nodes(twitter)
es = edges(twitter)
ts = timestamps(twitter)
