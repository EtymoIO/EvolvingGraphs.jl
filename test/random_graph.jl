tg = random_graph(10)
@test num_nodes(tg) == 10

g = random_evolving_graph(10, 5, 0.2)
@test num_nodes(g) == 10
@test num_timestamps(g) == 5
