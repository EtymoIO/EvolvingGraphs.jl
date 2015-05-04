####################################################
#
# Weighted EvolvingGraph type
#
#####################################################

type WeightedEvolvingGraph{V,T,W} <: AbstractEvolvingGraph{V,T,W}
    is_directed::Bool
    ilist::Vector{V}
    jlist::Vector{V}
    weights::Vector{W}
    timestamps::Vector{T} 
end

function weighted_evolving_graph{V,T,W}(ils::Vector{V}, 
                                        jls::Vector{V}, 
                                        ws::Vector{W}
                                        timestamps::Vector{T}; 
                                        is_directed::Bool = true)
    length(ils) == length(jls) == length(ws) == length(timestamps)|| 
            error("4 input vectors must have the same length.")
    return WeightedEvolvingGraph{V,T,W}(is_directed, ils, jls, ws, timestamps)
end



