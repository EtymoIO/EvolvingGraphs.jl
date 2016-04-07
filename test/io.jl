g = evolving_graph(AbstractString, AbstractString)
add_edge!(g, "a", "b", "t1")
add_edge!(g, "b", "c", "t1")
add_edge!(g, "c", "d", "t2")
add_edge!(g, "a", "b", "t2")

egwrite(g, "test1.csv")
g = egread("test1.csv")
@test num_nodes(g) == 4
@test num_timestamps(g) == 2

attribut1 =  Dict("a" => 3)
attribut2 =  Dict("a" => 4)

g2 = attribute_evolving_graph(AbstractString, AbstractString)

add_edge!(g2, ["a", "b", "c"], ["e", "f"], "t1", attribut1)
add_edge!(g2, ["d", "f"], ["d", "e", "a"], "t2", attribut2)

egwrite(g2, "test2.csv")
g2 = egread("test2.csv")

@test num_timestamps(g2) == 2

rm("test1.csv")
rm("test2.csv")
