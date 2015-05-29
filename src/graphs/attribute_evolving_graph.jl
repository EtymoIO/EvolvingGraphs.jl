
########################################
#
# AttributeEvolvingGraph type
#
########################################

type AttributeEvolvingGraph{V,T} <: AbstractEvolvingGraph{V,T}
    is_directed::Bool
    ilist::Vector{V}
    jlist::Vector{V}
    timestamps::Vector{T}
    attributes::AttributeDict
end
