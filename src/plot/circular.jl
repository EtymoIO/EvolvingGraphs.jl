"""
`circular_layout(adj_matrix)`

Position nodes on a circle.
"""
function circular_layout{T}(adj_matrix::AbstractArray{T, 2})
    n = size(adj_matrix, 1)
    if n == 1
        return zero(T), zero(T)
    else
        θ = linespace(0, 2π, n+1)[1:end-1]
        return cos(θ), sin(θ)
    end
end
