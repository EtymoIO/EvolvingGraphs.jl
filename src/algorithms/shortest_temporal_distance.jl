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
                                     v1::Tuple,
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
    for node in out_neighbors(g, v1)
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
`shortest_temporal_path(g, (v1, t1), (v2, t2) [, verbose = false])` finds the shortest 
temporal path from node `v1` at timestamp `t1` to node `v2` at timestamp 
`t2` on the evolving graph `g`. If `verbose = true`, prints the current path 
at each search step. 
"""->
shortest_temporal_path(g::AbstractEvolvingGraph, v1::Tuple, v2::Tuple; verbose = false) = _DFS_shortest_temporal_path(g, v1, v2, verbose = verbose)   

@doc doc"""
`shortest_temporal_distance(g, (v1, t1), (v2, t2))` finds the shortest 
temporal distance from node `v1` at timestamp `t1` to node `v2` at timestamp 
`t2` on the evolving graph `g`.
"""->
shortest_temporal_distance(g::AbstractEvolvingGraph, v1::Tuple, v2::Tuple) =
        shortest_temporal_path(g, v1, v2) == Union{} ? Inf : length(shortest_temporal_path(g, v1, v2)) - 1

