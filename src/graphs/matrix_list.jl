import Base: isempty

export IntMatrixList, MatrixList
export add_matrix!, int_matrix_list, forward_neighbors, backward_neighbors, nodelists

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



function int_matrix_list(g::EvolvingGraph)
    ts = timestamps(g)
    n = num_nodes(g)
    As = int_matrix_list(n)
    for t in ts
        add_matrix!(As, spmatrix(g, t))
    end
    As
end

is_directed(g::IntMatrixList) = true
nodelists(g::IntMatrixList) = g.nodelists


#`nodes(g)`returns the nodes of an evolving graph `g`.
function nodes(g::IntMatrixList) 
    n = length(g.nodelists)
    collect(1:n)
end

"""
`spmatrix(g, t)`

returns the sparse matrix representation of an evolving graph `g` 
at a given timestamp `t`.
"""
spmatrix(g::IntMatrixList, t::Int) = g.matrices[t]


"""
`spmatrix(g)`

converts an evolving graph `g` to an adjacency matrix of a  static graph.
"""
function spmatrix(g::IntMatrixList)
    n = length(g.nodelists)
    num_t = length(g.matrices)
    v1 = Int[]
    v2 = Int[]
    vals = Int[]
    for t = 1:num_t
        A = spmatrix(g, t)
        block = n*(t-1)
        for j = 1:n
            # diagonal blocks
            for k = A.colptr[j]:A.colptr[j+1] -1   
                push!(v1, A.rowval[k] + block)
                push!(v2, j + block)
                push!(vals, A.nzval[k])
            end
        end
    end
    # off-diagonal blocks
    for j = 1:n
        nods = g.nodelists[j]
        for (i, rowindx) in enumerate(nods)
            for colindx in nods[i+1:end]
                push!(v1, j + (rowindx-1)*n)
                push!(v2, j + (colindx-1)*n)
                push!(vals, one(Int))
            end
        end
    end
    sparse(v1, v2, vals, n*num_t, n*num_t)
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
                union!(nodes, A.rowval[k])
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

forward_trunc(v, i) = v[i:end]
backward_trunc(v,i) = v[i:-1:1]

for (f, vf, Af) in ((:forward_neighbors, :forward_trunc, :transpose), 
                        (:backward_neighbors, :backward_trunc, :identity))
    @eval begin
        function ($f)(g::IntMatrixList, v::Int, t::Int)
            ns = g.nodelists[v]
            m = length(nodes(g))
            idx = findfirst(ns, t)
            idx != 0 || return [(0, 0)]
            temporal_nodes = Tuple{Int, Int}[]
            ns = ($vf)(ns, idx)
            for i in ns
                push!(temporal_nodes, (v, i))
            end
            # the forward/backword neighbors at timestamp t 
            matorvec = (($Af)(spmatrix(g, t))*sparsevec([v], [1], m))
            if VERSION < v"0.5.0-dev+961"
                nods = matorvec.rowval
            else
                nods = matorvec.nzind
            end
            for nod in nods
                push!(temporal_nodes, (nod, ns[idx]))
            end
            temporal_nodes
        end
    end
end
for f in (:backward_neighbors, :forward_neighbors)
    @eval begin
        ($f)(g::IntMatrixList, v::Tuple{Int, Int}) = ($f)(g, v[1], v[2])
    end
end

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

deepcopy(g::MatrixList) = MatrixList(is_directed(g), 
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
