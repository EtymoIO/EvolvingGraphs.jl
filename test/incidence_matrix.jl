g = incidence_list(6)
@test length(nodes(g)) == 6
add_edge!(g, 1, 3, 1)
add_edge!(g, 2, 4, 2)
add_edge!(g, 3, 4, 4)
es = edges(g)
@test es[1] == (1,3,1)
@test es[2] == (2,4,2)
@test es[3] == (3,4,4)
@test num_timestamps(g) == 4
