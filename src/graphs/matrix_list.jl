##############################################
#
# Matrix List type
#
##############################################

type MatrixList{V,T} <: AbstractEvolvingGraph{V, Edge{V}, T}
    is_directed::Bool
    nodes::Vector{V}
    timestamps::Vector{T}
    matrices::Vector{Matrix{Bool}}
end

matrix_list{V,T}(::Type{V}, ::Type{T} ;is_directed::Bool = true) = MatrixList(is_directed, V[], T[], Matrix{Bool}[])
matrix_list(;is_directed::Bool = true) = matrix_list(Int, Int, is_directed = is_directed)

is_directed(g::MatrixList) = g.is_directed

nodes(g::MatrixList) = g.nodes
num_nodes(g::MatrixList) = length(g.nodes)

matrices(g::MatrixList) = g.matrices
matrix(g::MatrixList, i::Int) = g.matrices[i]
matrix(g::MatrixList, ij::UnitRange{Int}) = g.matrices[ij]

num_matrices(g::MatrixList) = length(g.matrices)

timestamps(g::MatrixList) = g.timestamps

copy(g::MatrixList) = MatrixList(is_directed(g), 
                                 deepcopy(g.nodes),
                                 deepcopy(g.timestamps),
                                 deepcopy(g.matrices))

# convert an evolving graph to MatrixList type
function matrix_list(g::AbstractEvolvingGraph)
    ns = nodes(g)
    ts = timestamps(g)
    ml = matrix_list(eltype(ns), eltype(ts), is_directed = is_directed(g))
    for i in ts
        push!(ml.matrices, matrix(g, i))
    end
    append!(ml.nodes, ns)
    append!(ml.timestamps, ts)
    ml
end

