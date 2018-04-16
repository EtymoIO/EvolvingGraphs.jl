# test evolving graph
g = EvolvingGraph{Node{Int}, String}()
add_edge!(g, 1, 2, "t1")
add_edge!(g, 2, 3, "t2")
add_edge!(g, 4, 2, "t2")
add_edge!(g, 4, 2, "t1")
add_edge!(g, 2, 1, "t3")

@test issorted(g) == false

g1 = sort_timestamps(g)

@test issorted(g1) == true
@test num_timestamps(g1) == 3

slice_timestamps!(g1, "t1", "t2")

@test num_timestamps(g1) == 2

p = sortperm(g.timestamps)

for e in edges(g1)
    @test (e in edges(g)) == true
end
