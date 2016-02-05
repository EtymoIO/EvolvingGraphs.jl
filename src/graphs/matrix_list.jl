import Base: isempty
export MatrixList, SimpleMatrixList, add_matrix!

# matrix list
type MatrixList{V,T,Tv<:Number} <: AbstractEvolvingGraph
    is_directed::Bool
    nodes::Vector{V}
    timestamps::Vector{T}
    matrices::Vector{SparseMatrixCSC{Tv}}
end

# simple matrix list
typealias SimpleMatrixList MatrixList{Int, Int, Bool}

function MatrixList{V,T, Tv}(nodes::Vector{V}, 
                             timestamps::Vector{T},
                             matrices::Vector{SparseMatrixCSC{Tv}};
                             is_directed::Bool=true)
    length(timestamps) == length(matrices) || throw(DimensionMismatch(""))
    MatrixList(is_directed, nodes, timestamps, matrices)
end

"""
 `MatrixList(;is_directed=true)`
  
initializes a simple matrix list. 
"""
MatrixList(;is_directed::Bool=true) = MatrixList(Int[], Int[], 
                                                 SparseMatrixCSC{Bool}[],
                                                 is_directed = is_directed)

isempty(g::MatrixList) = isempty(g.nodes)
is_directed(g::MatrixList) = g.is_directed
nodes(g::MatrixList) = g.nodes
num_nodes(g::MatrixList) = length(g.nodes)

matrices(g::MatrixList) = g.matrices
num_matrices(g::MatrixList) = length(g.matrices)

matrix(g::MatrixList, i::Int) = g.matrices[i]
matrix(g::MatrixList, ur::UnitRange{Int}) = g.matrices[ur]

timestamps(g::MatrixList) = g.timestamps
num_timestamps(g::MatrixList) = length(timestamps(g))

copy(g::MatrixList) = MatrixList(is_directed(g), 
                                 deepcopy(g.nodes),
                                 deepcopy(g.timestamps),
                                 deepcopy(g.matrices))

"""
 `MatrixList(g)`

converts an evolving graph `g` to a MatrixList type object.
"""
function MatrixList(g::AbstractEvolvingGraph)
    ns = nodes(g)
    ts = timestamps(g)
    n = length(ts)
    matrices = Array(SparseMatrixCSC{Float64}, n)
    for (i,t) = enumerate(ts)
        matrices[i] = spmatrix(g,t)
    end
    MatrixList(ns, ts, matrices, is_directed = is_directed(g))
end


"""
  `add_matrix!(ms, A)`

adds a sparse matrix `A` to a SimpleMatrixList `ms`.
"""
function add_matrix!(ms::SimpleMatrixList, A::SparseMatrixCSC)
    n = A.n
    m = A.m
    n == m || throw(DimensionMismatch("A must be a square matrix."))
    if !isempty(ms)
        n == ms.matrices[1].n || throw(DimensionMismatch(""))
    end
    if is_directed(ms) == false
        issym(A) || error("A must be a symmetric matrix.")
    end
    ms.nodes = union(ms.nodes, unique(A.rowval))
    push!(ms.timestamps, length(ms.timestamps)+1)
    push!(ms.matrices, A)
    ms
end

"""
  `add_matrix!(ms, A, nodes)`

adds a sparse matrix `A` which corresponding to a graph with
nodes `nodes` to a MatrixList `ms`.
"""
function add_matrix!(ms::MatrixList, A::SparseMatrixCSC, 
                     nodes::Vector{Int})

end
