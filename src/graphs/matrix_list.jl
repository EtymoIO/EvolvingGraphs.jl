import Base: isempty

export IntMatrixList, MatrixList
export add_matrix!, int_matrix_list, forward_neighbours

type IntMatrixList <: AbstractEvolvingGraph
    nodelists::Vector{Vector{Int}}
    matrices::Vector{SparseMatrixCSC{Int, Int}}
end

"""
`int_matrix_list(n)`

initializes an evolving graph with `n` nodes represented by IntMatrixList.
"""
function int_matrix_list(n::Int)
    ns = Vector{Int}[]
    for i = 1:n
        push!(ns, Int[])
    end
    IntMatrixList(ns, Vector{SparseMatrixCSC{Int, Int}}[])
end

is_directed(g::IntMatrixList) = true

"""
`spmatrix(g, t)`

returns the sparse matrix representation of an evolving graph `g` 
at a given timestamp `t`.
"""
spmatrix(g::IntMatrixList, t::Int) = g.matrices[t]


"""
`nodes(g)`

returns the nodes of an evolving graph `g`.
"""
function nodes(g::IntMatrixList) 
    n = length(g.nodelists)
    collect(1:n)
end

num_timestamps(g::IntMatrixList) = length(g.matrices)

"""
`add_matrix!(g, A)`

adds a new matrix to an evolving graph `g`.
"""
function add_matrix!(g::IntMatrixList, A::SparseMatrixCSC)
    n = A.n
    n == length(g.nodelists) || throw(DimensionMismatch())
    nodes = IntSet() # sorted set of integers
    for j = 1:n
        cols = A.colptr[j]:A.colptr[j+1] -1
        if length(cols) > 0
            union!(nodes, j)
            for k in cols
                i = A.rowval[k]
                union!(nodes, i)
            end
        end
    end
    val = length(g.matrices) + 1
    for i in nodes
        push!(g.nodelists[i], val)
    end
    push!(g.matrices, A)
    g
end

function forward_neighbours(g::IntMatrixList, v::Int, t::Int)
    ns = g.nodelists[v]
    m = length(nodes(g))
    idx = findfirst(ns, t)
    idx != 0 || return [(0, 0)]
    temporal_nodes = Tuple{Int, Int}[]
    # the active node itself at later timestamp
    for i in ns[idx:end]
        push!(temporal_nodes, (v, i))
    end
    # the out neighbours at timestamp t 
    nods = (spmatrix(g, t)'*sparsevec([v], [1], m)).rowval
    for nod in nods
        push!(temporal_nodes, (nod, idx))
    end
    temporal_nodes
end
forward_neighbours(g::IntMatrixList, v::Tuple{Int, Int}) = forward_neighbours(g, v[1], v[2]) 
backward_neighbours(g::IntMatrixList, v::Int, t::Int) = () 



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
