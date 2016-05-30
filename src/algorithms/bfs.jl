export breadth_first_visit

# _breadth_first_visit(g, (v1, t1))
# find all reachable nodes from (v1, t1)
function _breadth_first_visit(g::AbstractEvolvingGraph, s::Tuple)
    level =  Dict(s => 0)
    i = 1
    fronter = [s]
    reachable = [s]
    while length(fronter) > 0
        next = Tuple[]
        for u in fronter
            for v in forward_neighbors(g, u)
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
function breadth_first_visit{V, E, T}(g::EvolvingGraph{V, E, T}, v::V, t::T)
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
function breadth_first_visit{V, E, T}(g::EvolvingGraph{V, E, T}, v, t)
    v = find_node(g, v)
    breadth_first_visit(g, v, T(t))
end

"""
    breadth_first_visit(g, v, t)

Return all the reachable active nodes from a given temporal node
`(v,t)`.
"""
function breadth_first_visit(g::AbstractEvolvingGraph, s::Tuple)
    _breadth_first_visit(g, s)
end
breadth_first_visit(g::IntEvolvingGraph, v::Int, t::Int) = breadth_first_visit(g, (v,t))
