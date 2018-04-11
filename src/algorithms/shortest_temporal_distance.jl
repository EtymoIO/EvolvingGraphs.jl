# Reference: Temporal Distance Metrics for Social Network Analysis,
#  John Tang, Mirco Musolesi, Cecilia Mascolo and Vito Latora,
# 2009.


# find the shortest temporal path via depth first search
function _DFS_shortest_temporal_path(g::AbstractEvolvingGraph,
                                     v1::Tuple,  # v1 and v2 are active nodes (v,t)
                                     v2::Tuple,
                                     path = TemporalPath(),
                                     shortest =  Union{};
                                     verbose::Bool = false)
    path = deepcopy(path)
    path.walks = [path.walks; v1]

    if verbose
        println("current:", path)
    end

    if v1 == v2
        return path
    end
    for node in forward_neighbors(g, v1)
        if !(has_node(path, node)) # avoid cycles
            if node[2] <= v2[2] # avoid searching nodes at timestamps > v2[2]
                if (shortest ==  Union{}) || (spatial_length(path) < spatial_length(shortest))
                    newPath = _DFS_shortest_temporal_path(g, node, v2, path, shortest, verbose = verbose)
                    if newPath !=  Union{}
                        shortest = newPath
                    end
                end
            end
        end
    end
    return shortest
end


"""
        shortest_temporal_path(g, v1, t1, v2, t2 [, verbose = false])

Find the shortest temporal path from node `v1` at timestamp `t1`
to node `v2` at timestamp `t2` on the evolving graph `g`.
If `verbose = true`, prints the current path at each search step.
"""
shortest_temporal_path(g::AbstractEvolvingGraph, v1, t1, v2, t2; verbose::Bool = false) =    _DFS_shortest_temporal_path(g, (v1, t1), (v2, t2), verbose = verbose)
shortest_temporal_path{V,  T}(g::EvolvingGraph{V, T},
                                                        v1::V, t1::T, v2::V, t2::T;
                                                        verbose::Bool = false) =
   _DFS_shortest_temporal_path(g, (v1, t1), (v2, t2), verbose = verbose)



function shortest_temporal_path{V, T}(g::EvolvingGraph{V, T}, v1, t1, v2, t2;
                                                                        verbose::Bool = false)
    v1 = find_node(g, v1)
    v2 = find_node(g, v2)
    shortest_temporal_path(g, v1, T(t1), v2, T(t2), verbose = verbose)
end

"""
        shortest_temporal_distance(g, v1, t1, v2, t2)

Find the shortest temporal distance from node `v1` at timestamp `t1` to
node `v2` at timestamp `t2` on the evolving graph `g`.
"""
function shortest_temporal_distance(g::AbstractEvolvingGraph, v1, t1, v2, t2)
    if shortest_temporal_path(g, v1, t1, v2, t2) == Union{}
        return Inf
    else
        return length(shortest_temporal_path(g, v1, t1, v2, t2)) - 1
    end
end

"""
        temporal_efficiency(g, v1, t1, v2, t2)

Find the temporal efficiency from node `v1` at timestamp `t1` to node `v2` at timestamp
`t2` on the evolving graph `g`.
"""
temporal_efficiency(g::AbstractEvolvingGraph, v1, t1, v2, t2) =
         one(Float64)/shortest_temporal_distance(g, v1, t1, v2, t2)

"""
        global_temporal_efficiency(g, t1, t2)

Return the global temporal efficiency of the evolving graph `g` between
timestamp `t1` and `t2`. The global temporal efficiency is a measure of
how well information flow between two given timestamps.
"""
function global_temporal_efficiency(g::AbstractEvolvingGraph, t1, t2)
    result = zero(Float64)
    for j in nodes(g)
        for i in nodes(g)
            result += temporal_efficiency(g, i,t1, j,t2)
        end
    end
    result
end
