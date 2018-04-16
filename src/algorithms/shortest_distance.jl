type Path <: AbstractPath
    walks::Vector
end

Path() = Path(Any[])

length(p::Path) = length(p.walks)

has_node(p::Path, v) = v in p.walks

==(p1::Path, p2::Path) = (p1.walks == p2.walks)

# find the shortest path via depth first search
function _DFS_shortest_path{V}(g::DiGraph{V},
                               v1::V,
                               v2::V,
                               path = Path(),
                               shortest =  Union{};
                               verbose = false)

    path = deepcopy(path)
    path.walks = [path.walks; v1]

    if verbose
        println("current:", path)
    end

    if v1 == v2
        return path
    end

    for node in forward_neighbors(g, v1)
        if !has_node(path, node)
            if (shortest ==  Union{}) || length(path) < length(shortest)
                newPath = _DFS_shortest_path(g, node, v2, path, shortest, verbose = verbose)
                if !(newPath ==  Union{})
                    shortest = newPath
                end
            end
        end
    end
    return shortest
end

@doc doc"""
`shortest_path(g, v1, v2 [, verbose = false])` finds the shortest path from `v1` to `v2` on
the time graph `g`. if `verbose = true`, prints the current path at each search step.
"""->
shortest_path{V}(g::DiGraph{Node{V}}, v1::V, v2::V; verbose = false) =
_DFS_shortest_path(g, make_node(g,v1), make_node(g,v2), verbose = verbose)

#shortest_path{V}(g::DiGraph{AttributeNode{V}}, v1::V, v2::V; verbose = false) =
#_DFS_shortest_path(g, make_node(g,v1), make_node(g,v2), verbose = verbose)



@doc doc"""
`shortest_distance(g, v1, v2)` finds the shortest distance from `v1` to `v2`
on the time graph `g`.
"""->
shortest_distance{V}(g::DiGraph{Node{V}}, v1::V, v2::V) =
          shortest_path(g, v1, v2) == Union{} ? Inf : length(shortest_path(g, v1, v2)) - 1

#shortest_distance{V}(g::DiGraph{AttributeNode{V}}, v1::V, v2::V) =
#            shortest_path(g, v1, v2) ==  Union{} ? Inf : length(shortest_path(g, v1, v2)) - 1
