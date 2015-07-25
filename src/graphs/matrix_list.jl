##############################################
#
# Matrix List type
#
##############################################

type MatrixList{V,T} <: AbstractEvolvingGraph{V, Edge{V}, T}
    is_directed::Bool
    nodes::Vector{V}
    timestamps::Vector{T}
    matrices::Vector{Matrix{V}}
end

matrix_list{V,T}(::Type{V}, ::Type{T} ;is_directed::Bool = true) = MatrixList(is_directed, V[], T[], Matrix{V}[])
matrix_list(;is_directed::Bool = true) = matrix_list(Int, Int, is_directed = is_directed)

is_directed(g::MatrixList) = g.is_directed

nodes(g::MatrixList) = g.nodes
num_nodes(g::MatrixList) = length(g.nodes)

matrices(g::MatrixList) = g.matrices
num_matrices(g::MatrixList) = length(g.matrices)

timestamps(g::MatrixList) = g.timestamps

copy(g::MatrixList) = MatrixList(is_directed(g), 
                                 deepcopy(g.nodes),
                                 deepcopy(g.timestamps),
                                 deepcopy(g.matrices))



