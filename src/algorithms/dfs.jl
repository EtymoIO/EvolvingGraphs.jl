"""
    depth_first_impl(g, i, j)

Find the shortest temporal path between TimeNode `i` and `j` on an evolving graph `g` using DFS.
"""
function depth_first_impl(g::EvolvingGraph, i::TimeNode, j::TimeNode, p = TemporalPath(), shortest = TemporalPath())

    p = deepcopy(p)
    push!(p, i)
    println("Current path: $(p)")

    if i == j
        return p
    end

    for n in forward_neighbors(g, i)
        if !(n in p)
            if node_timestamp(n) <= node_timestamp(j)
                if shortest == TemporalPath() || (length(p) < length(shortest))
                    new_p = depth_first_impl(g, n, j, p, shortest)

                    if new_p != TemporalPath()
                        shortest = new_p
                    end
                end
            end
        end
    end
    return shortest

end
