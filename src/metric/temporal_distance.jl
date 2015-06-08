# Reference: Temporal Distance Metrics for Social Network Analysis,
#  John Tang, Mirco Musolesi, Cecilia Mascolo and Vito Latora,
# 2009.  
type TemporalPath{T, P}
    timestamps::Vector{T}
    path::Vector{P}
    TemporalPath() = new(Vector(), Vector())
end


function show(io::IO, p::TemporalPath)
    result = ""
    for i in 1:length(p.path)
        if i == length(p.path) 
            result = string(result, "(", p.path[i], "," , p.timestamps[i], ")")
        else
            result = string(result, "(", p.path[i], "," , p.timestamps[i], ")", "->")
        end
    end
    print(io, result)
end

# the temporal path between node v1 and v2
# t_min, t_max: the 
function temporal_path(g::AbstractEvolvingGraph, v1, v2, t_min, 
                       t_max, h::Int, p = TemporalPath(), shortest = None)
    push!(p.path, v1.key)
    push!(p.timestamps, v1.time)
    g = slice(g, t_min, t_max)
    if v1 == v2
        return p
    end
    for node in out_neighbors(g, v1)
        if !(node.key in p.path && node.time in p.path)
            if shortest = None || length(p.path) < length(shortest.path)
                newPath = temporal_path(g, node, v2, t_min, t_max, h, p, shortest)
                if newPath != None
                    shortest = newPath
                end
            end
        end
    end
    return paths
end

# the temporal path start from v at timestamp t_min and 
function temporal_path(g::AbstractEvolvingGraph, v, t_min, t_max, h::Int)
    
end

function shortest_temporal_distance(g::AbstractEvolvingGraph, v1, v2, t_min, 
                                    t_max, h::Int)
    paths = temporal_path(g, v1, v2, t_min, t_max, h)
    
end
