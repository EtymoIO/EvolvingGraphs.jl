# Breadth First Search
function BFS(g::AdjacencyList, s::Node)
    level = {s => 0}
    i = 1
    froniter = [s]
    while length(froniter) != 0
        next = Node[]
        for u in froniter
            for v in out_neighbors(g, u)
                if !(v in keys(level))
                    level[v] = i
                    push!(next, v)
                end
            end
        end
        froniter = next
        i += 1
    end
    return level
end
