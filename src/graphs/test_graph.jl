function build_tree(;is_directed = true)
    g = AdjacencyList(is_directed = is_directed)
    for element in ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']
        add_node!(g, Node(element))
    end
    add_edge!(g, Edge('a', 'b'))
    add_edge!(g, Edge('b', 'd'))
    add_edge!(g, Edge('b', 'e'))
    add_edge!(g, Edge('b', 'f'))
    add_edge!(g, Edge('a', 'c'))
    add_edge!(g, Edge('c', 'g'))
    add_edge!(g, Edge('g', 'h'))
     
    return g
end
