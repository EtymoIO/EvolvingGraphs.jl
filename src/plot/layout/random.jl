"""
`random_layout(adj_matrix)`

Randomly position nodes in a unit square.
"""
random_layout{T}(adj_matrix::AbstractArray{T, 2}) = 
(n = size(adj_matrix, 1); (rand(n), rand(n)))
