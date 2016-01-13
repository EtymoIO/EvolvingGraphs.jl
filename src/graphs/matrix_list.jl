export MatrixList, SimpleMatrixList

# matrix list
type MatrixList{V,T,Tv<:Number} <: AbstractEvolvingGraph
    is_directed::Bool
    nodes::Vector{V}
    timestamps::Vector{T}
    matrices::Vector{SparseMatrixCSC{Tv}}
end

# simple matrix list
typealias SimpleMatrixList MatrixList{Int, Int, Bool}

function MatrixList{V,T,Tv}(nodes::Vector{V}, 
                            timestamps::Vector{T},
                            matrices::Vector{SparseMatrixCSC{Tv}};
                            is_directed::Bool=true)
    length(timestamps) == length(matrices) || throw(DimensionMismatch(""))
    MatrixList(is_directed, nodes, timestamps, matrices)
end
MatrixList(;is_directed::Bool=true) = MatrixList(Int[], Int[], 
                                                 SparseMatrixCSC{Bool}[],
                                                 is_directed = is_directed)

is_directed(g::MatrixList) = g.is_directed
nodes(g::MatrixList) = g.nodes
num_nodes(g::MatrixList) = length(g.nodes)

matrices(g::MatrixList) = g.matrices
num_matrices(g::MatrixList) = length(g.matrices)

matrix(g::MatrixList, i::Int) = g.matrices[i]
matrix(g::MatrixList, ur::UnitRange{Int}) = g.matrices[ur]

timestamps(g::MatrixList) = g.timestamps

copy(g::MatrixList) = MatrixList(is_directed(g), 
                                 deepcopy(g.nodes),
                                 deepcopy(g.timestamps),
                                 deepcopy(g.matrices))

# convert an evolving graph to MatrixList type
function MatrixList(g::AbstractEvolvingGraph)
    ns = nodes(g)
    ts = timestamps(g)
    n = length(ts)
    matrices = Array(SparseMatrixCSC, n)
    for i = 1:n
        matrices[i] = sparse(matrix(g, i))
    end
    MatrixList(ns, ts, matrices, is_directed = is_directed(g))
end
