# Reference: Temporal Distance Metrics for Social Network Analysis,
#  John Tang, Mirco Musolesi, Cecilia Mascolo and Vito Latora,
# 2009.  
type TemporalPath <: AbstractPath
    walks::Vector{Tuple}
end

TemporalPath() = TemporalPath([])
length(p::TemporalPath) = length(p.walks)

# spatical length disregard time
spatial_length(p::TemporalPath) = length(unique(map(x -> x[1], p.walks)))
has_node(p::TemporalPath, v::Tuple) = v in p.walks
==(p1::TemporalPath, p2::TemporalPath) = (p1.walks == p2.walks)

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



@doc doc"""
        shortest_temporal_path(g, v1, t1, v2, t2 [, verbose = false])

Find the shortest temporal path from node `v1` at timestamp `t1` 
to node `v2` at timestamp `t2` on the evolving graph `g`. 
If `verbose = true`, prints the current path at each search step. 
"""->
shortest_temporal_path(g::AbstractEvolvingGraph, v1, t1, v2, t2; verbose::Bool = false) =    _DFS_shortest_temporal_path(g, (v1, t1), (v2, t2), verbose = verbose)
shortest_temporal_path{V,  E, T}(g::EvolvingGraph{V, E, T}, 
                                                        v1::V, t1::T, v2::V, t2::T;
                                                        verbose::Bool = false) =  
   _DFS_shortest_temporal_path(g, (v1, t1), (v2, t2), verbose = verbose)



function shortest_temporal_path{V, E, T}(g::EvolvingGraph{V, E, T}, v1, t1, v2, t2;
                                                                        verbose::Bool = false)
    v1 = find_node(g, v1)
    v2 = find_node(g, v2)
    shortest_temporal_path(g, v1, T(t1), v2, T(t2), verbose = verbose)
end

@doc doc"""
        shortest_temporal_distance(g, v1, t1, v2, t2)

Find the shortest temporal distance from node `v1` at timestamp `t1` to 
node `v2` at timestamp `t2` on the evolving graph `g`.
"""->
function shortest_temporal_distance(g::AbstractEvolvingGraph, v1, t1, v2, t2)
    if shortest_temporal_path(g, v1, t1, v2, t2) == Union{} 
        return Inf 
    else
        return length(shortest_temporal_path(g, v1, t1, v2, t2)) - 1
    end
end
