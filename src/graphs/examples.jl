
function build_evolving_graph(;is_directed = true)
    a = [1, 2, 3, 3, 4, 2, 6, 3]
    b = [2, 3, 2, 5, 3, 5, 1, 5]
    times = [1, 2, 2, 2, 3, 3, 3, 3]
    return evolving_graph(a, b, times, is_directed = is_directed)
end

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

function build_evolving_graph2(;is_directed = true)
    g = TimeEdgeList(is_directed = is_directed)
    a = IndexNode(1, 'a')
    b = IndexNode(2, 'b')
    c = IndexNode(3, 'c')
    d = IndexNode(4, 'd')

    for i in [a, b, c, d]
        add_node!(g, i)
    end

    add_edge!(g, a, b, 1)  # IndexNode a and b at time 1
    add_edge!(g, b, c, 1)
    add_edge!(g, a, c, 1)
    add_edge!(g, a, d, 1)
    add_edge!(g, b, a, 1)
    add_edge!(g, c, a, 1)
    add_edge!(g, a, b, 2)
    add_edge!(g, b, c, 2)
    add_edge!(g, a, c, 2)
    add_edge!(g, a, c, 3)
    add_edge!(g, b, c, 3)
    add_edge!(g, c, a, 3)
    return g
end
