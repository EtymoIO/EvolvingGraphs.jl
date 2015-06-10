# Reference: Temporal Distance Metrics for Social Network Analysis,
#  John Tang, Mirco Musolesi, Cecilia Mascolo and Vito Latora,
# 2009.  
type TemporalPath <: AbstractPath
    walks::Vector{Tuple}
end

TemporalPath() = TemporalPath([])

length(p::TemporalPath) = length(p.walks)

has_node(p::TemporalPath, v::Tuple) = v in p.walks



# the temporal path between node v1 and v2
# t_min, t_max: the 
function dfs_visit(g, v)
    
end

function shortest_temporal_path(g::AbstractEvolvingGraph, 
                                v1::Tuple, 
                                v2::Tuple, 
                                p = TemporalPath(), 
                                shortest = None;
                                verbose = true)    
    push!(p.path, v1)
    if verbose
        print("current path:", p, "\n")
    end
    
    if v1 == v2
        return p
    end
    for node in out_neighbors(g, v1)
        if !(has_node(p, node))
           
            if (shortest == None) || (length(p) < length(shortest))
                newPath = shortest_temporal_path(g, node, v2, p, shortest, verbose = verbose)
                if newPath != None
                    shortest = newPath
                end
            end
        end
    end
    return shortest
end


shortest_temporal_distance(g::AbstractEvolvingGraph, v1::Tuple, v2::Tuple) =
        shortest_temporal_path(g, v1, v2) == None ? Inf : length(shortest_temporal_path(g, v1, v2))

