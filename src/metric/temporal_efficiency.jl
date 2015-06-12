
@doc doc"""
`temporal_efficiency(g, (v1, t1), (v2, t2))` finds the temporal 
efficiency from node `v1` at timestamp `t1` to node `v2` at timestamp
`t2` on the evolving graph `g`.
"""->
temporal_efficiency(g::AbstractEvolvingGraph, v1::Tuple, v2::Tuple) = 
         one(Float64)/shortest_temporal_distance(g, v1, v2) 

@doc doc"""
`global_temporal_efficiency(g, t1, t2)` returns the global temporal 
efficiency of the evolving graph `g` between timestamp `t1` and `t2`.
The global temporal efficiency is a measure of how well information flow
between two given timstamps. 
"""->
function global_temporal_efficiency(g::AbstractEvolvingGraph, t1, t2) 
    g = slice(g, t1, t2)
    result = zero(Float64)
    for j in nodes(g)
        for i in nodes(g)
            try 
                result += temporal_efficiency(g, (i,t1), (j,t2))
            end
        end
    end
    result
end
       
