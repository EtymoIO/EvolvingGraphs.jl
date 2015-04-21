# return a ranking vector
function katz_centrality{T}(g::Array{T, 3}, α::Real = 0.3, β::Real = 0.2; 
                            broadcast::Bool = true, receive::Bool = false)
    n, n, k = size(g)
    A = Array(T, n, n)
    v = Array()
    for i = 1:k
        copy!(A, )
        S = (I + e^(-βΔt)*S)*(I - αA)^(-1) - I
    end
    if broadcast
        v1 = S*ones(n)
    end
    if receive
        v2 = At_mul_B(S, ones(n))
    end
end

# return a dictionary: node => value
function katz_centrality(g::TimeTensor, α::Real = 0.3, β::Real = 0.2;
                         broadcast::Bool = true, receive::Bool = false)


end
