mutable struct Graph{V<:AbstractNode, E<:AbstractEdge, IncList, VK} <: AbstractStaticGraph{V, E}
    nodes::Vector{V}
    edges::Vector{E}
    ilist::IncList # incidence list
    indexof::Dict{VK,Int}
end
