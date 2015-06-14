# use shortest temporal distance is a overkill, need to improve later.
@doc doc"""
`temporally_connected(g, (v1, t1), (v2, t2))` returns `true` if there is path 
from `v1` at timestamp `t1` to `v2` at timestamp `t2` and `false` otherwise.
"""->
temporal_connected(g::AbstractEvolvingGraph, v1::Tuple, v2::Tuple) = 
              shortest_temporal_distance(g, v1, v2) == Inf ? false : true 

# true = 1, false = 0

@doc doc"""
`weak_connected(g, v1, v2)` returns `true` if there is a temporal path 
from `v1` to `v2` at any timestamps.
"""->
function weak_connected(g::AbstractEvolvingGraph, v1, v2) 
    sum = false
    ts = timestamps(g)
    n = length(ts)
    for i in 1:n
        for j in i:n
            sum += temporal_connected(g, (v1, ts[i]), (v2, ts[j]))
        end
    end
    return sum > 0 ? true : false
end

# _breath_first_visit(g, (v1, t1))
# find all reachable nodes from (v1, t1)
function _breath_first_visit{V}(g::AbstractEvolvingGraph{V}, s::Tuple)
    level = @compat Dict(s => 0)
    i = 1
    fronter = [s]
    reachable = [s[1]]
    while length(fronter) > 0
        next = Tuple[]
        for u in fronter
            for v in out_neighbors(g, u)
                if !(v in keys(level))
                    level[v] = i
                    #println("level:", level)
                    v[1] in reachable || push!(reachable, v[1])
                    push!(next, v)
                end
            end
        end
        fronter = next
        i += 1
    end
    reachable
end


@doc doc"""
`weak_connected_components(g)` finds the weakly connected components
of an evolving graph `g`, i.e, each node in the set is weakly 
connected to all the other nodes.
"""->
function weak_connected_components{V}(g::AbstractEvolvingGraph{V})
    components = Array(Vector{V}, 0)
    nodelist = V[]
    reachable = V[]

    for node in nodes(g)
        if !(node in nodelist)
            maxreachable = V[]
            for t in timestamps(g) 
                reachable = _breath_first_visit(g, (node, t))
                if length(reachable) > length(maxreachable)
                    maxreachable = reachable
                end
            end
            append!(nodelist, maxreachable)
            push!(components, maxreachable)
        end
    end
    components
end
