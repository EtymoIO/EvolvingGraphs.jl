type Rank{V}
    broadcast::Dict{V, Real}
    receive::Dict{V, Real}
end


# return the broadcast centrality
function katz_centrality(g::EvolvingGraph, α::Real = 0.3, β::Real = 0.2)
    n = num_nodes(g)
    ns = nodes(g)
    ts = timestamps(g) 
    S = spzeros(Bool, n, n)
    I = speye(Float64, n)
    v1 = Array(Float64, n) 
    Δt = 1
    for t in ts 
        Δt += 0.01
        S = (I + e^(-β*Δt)*S)*(I + α*spmatrix(g,t) + 
                               α^2*spmatrix(g,t)^2 + α^3*spmatrix(g,t)^3) - I
        S = S/norm(S)
    end

    A_mul_B!(v1, S, ones(n))

    return collect(zip(ns, v1))
    
end


