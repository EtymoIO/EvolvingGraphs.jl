export AdjMatrixList

type AdjMatrixList{Tv} <:AbstractEvolvingGraph
    adjlists::Vector{Vector{Int}}
    matrices::Vector{SparseMatrixCSC{Tv}}
end

is_directed(g::AdjMatrixList) = true
