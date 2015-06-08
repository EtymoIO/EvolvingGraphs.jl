# Reference: Temporal Distance Metrics for Social Network Analysis,
#  John Tang, Mirco Musolesi, Cecilia Mascolo and Vito Latora,
# 2009.  

# the temporal path between node v1 and v2
function temporal_path(g::AbstractEvolvingGraph, v1, v2, t_min, 
                       t_max, h::Int)
    path = Any[]
    ns = nodes(g)
    (v1 in ns && v2 in ns) || error("nodes are not on the graph.")
    
    return path
end
