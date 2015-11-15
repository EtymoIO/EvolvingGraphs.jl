function build_time_graph()
    g = time_graph(Int, 1)
    add_edge!(g, 0, 1)
    add_edge!(g, 1, 2)
    add_edge!(g, 2, 3)
    add_edge!(g, 2, 4)
    add_edge!(g, 3, 4)
    add_edge!(g, 3, 5)
    add_edge!(g, 0, 2)
    add_edge!(g, 1, 0)
    add_edge!(g, 3, 1)
    add_edge!(g, 4, 0)
    g
end

g = build_time_graph()

p = shortest_path(g, 0, 5, verbose = true)

p2 = Path([make_node(g,0), make_node(g,2), make_node(g,3), make_node(g,5)])

@test p == p2

@test shortest_distance(g,  0,  5) == 3
