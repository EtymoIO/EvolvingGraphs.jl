"""
    MatrixList

Data type of storing a list of sparse matrices in CSC format.
"""
type MatrixList
    matrices::Array{SparseMatrixCSC, 1}
end
MatrixList() = MatrixList(SparseMatrixCSC[])


"""
    evolving_graph_to_matrices(g)

Convert an evolving graph `g` to a matrix list.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> g = EvolvingGraph()
Directed EvolvingGraph 0 nodes, 0 static edges, 0 timestamps

julia> add_bunch_of_edges!(g, [(1,2,1), (2,4,1), (2,3,1), (3,4,2), (1,3,3)])
Directed EvolvingGraph 4 nodes, 5 static edges, 3 timestamps

julia> ml = evolving_graph_to_matrices(g)
MatrixList (3 matrices)

julia> sparse_adjacency_matrix(ml, 1)
4×4 SparseMatrixCSC{Float64,Int64} with 3 stored entries:
  [1, 2]  =  1.0
  [2, 3]  =  1.0
  [2, 4]  =  1.0

julia> sparse_adjacency_matrix(ml,2)
4×4 SparseMatrixCSC{Float64,Int64} with 1 stored entry:
  [4, 3]  =  1.0
```
"""
function evolving_graph_to_matrices(g::AbstractEvolvingGraph)
    ts = unique_timestamps(g)
    n = length(ts)
    matrices = Array{SparseMatrixCSC{Float64}}(n)

    for (i,t) = enumerate(ts)
        matrices[i] = sparse_adjacency_matrix(g,t)
    end
    MatrixList(matrices)
end


"""
    matrices(ml)

Return a list of matrices in MatrixList `ml`.
"""
matrices(ml::MatrixList) = ml.matrices

"""
    num_matrices(ml)

Return the number of matrices in MatrixList `ml`.
"""
num_matrices(ml::MatrixList) = length(ml.matrices)
sparse_adjacency_matrix(ml::MatrixList, i::Int) = ml.matrices[i]

length(ml::MatrixList) = length(ml.matrices)
Base.start(ml::MatrixList) = 1
Base.next(ml::MatrixList, state) = (ml.matrices[state], state+1)
Base.done(ml::MatrixList, state) = state > length(ml.matrices)

push!(ml::MatrixList, m::SparseMatrixCSC) = (push!(ml.matrices, m); ml)
