
function build_evolving_graph(;is_directed = true)
    a = [1, 2, 3, 3, 4, 2, 6]
    b = [2, 3, 2, 5, 3, 5, 1]
    times = [1, 2, 2, 2, 3, 3, 3]
    return evolving_graph(a, b, times, is_directed = is_directed)
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
