g = random_evolving_graph(5, 4)

egwrite(g, "test1.csv")
g = egread("test1.csv")
@test num_nodes(g) == 5
@test num_timestamps(g) == 4

attribut1 = @compat Dict("a" => 3)
attribut2 = @compat Dict("a" => 4)

g2 = attribute_evolving_graph(AbstractString, AbstractString)

add_edge!(g2, ["a", "b", "c"], ["e", "f"], "t1", attribut1)
add_edge!(g2, ["d", "f"], ["d", "e", "a"], "t2", attribut2)

egwrite(g2, "test2.csv")
g2 = egread("test2.csv")

@test num_timestamps(g2) == 2

rm("test1.csv")
rm("test2.csv")
