function breadth_first_impl{V, T}(g::AbstractEvolvingGraph{V, T}, v::V, t::T)
    level = Dict((v,t) => 0)
    i = 1
    fronter = [(v,t)]
    reachable = [(v,t)]
    while length(fronter) > 0
        next = Tuple{V,T}[]
        for u in fronter
            for v in forward_neighbors(g, u[1], u[2])
                if !(v in keys(level))
                    level[v] = i
                    push!(reachable, v)
                    push!(next, v)
                end
            end
        end
        fronter = next
        i += 1
    end
    reachable
end
"""
    breadth_first_visit(g, v, t)

Return all the reachable active nodes from a given temporal node
`(v,t)`.
"""
function breadth_first_visit{V, T}(g::EvolvingGraph{V, T}, v, t)
    new_v = find_node(g, v)
    breadth_first_impl(g, new_v, T(t))
end
breadth_first_visit(g::IntEvolvingGraph, v, t) = breadth_first_impl(g, v, t)
