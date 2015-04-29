# compute the Katz centrality broadcast vector of a given
# evolving graph. 
function katz_centrality(g::EvolvingGraph, α::Real = 0.3)
    n = num_nodes(g)
    ns = nodes(g)
    ts = timestamps(g)
    A = spzeros(Float64, n, n)
    I = speye(Float64, n)
    v = ones(Float64, n)
    for t in ts
        copy!(A, spmatrix(g,t))
        copy!(v, (I - α*A)\v)
        copy!(v, v/norm(v))
    end
    return collect(zip(ns, v))
end

# compute the Katz centrality of a given evolving graph
# α and β are parameters that controls the influence of 
# long walks and walks happened long time ago.
# mode = :broadcast (broadcast centrality vector)
#      = :receive (receive centrality vector)
#      = :matrix (the communicability matrix)
function katz_centrality(g::EvolvingGraph, 
                         α::Real, 
                         β::Real;
                         mode::Symbol = :broadcast)
    n = num_nodes(g)
    ns = nodes(g)
    ts = timestamps(g) 
    S = spzeros(Float64, n, n)
    A = spzeros(Float64, n, n)
    I = speye(Float64, n)
    v = Array(Float64, n) 
    Δt = 1.
    for t in ts
        Δt += 0.01
        copy!(A, spmatrix(g,t))
        copy!(S, (I + e^(-β*Δt)*S)*(I + α*A + α^2*A^2) - I)
        copy!(S, S/norm(S,1))
    end

    if mode == :matrix
        return S
    elseif mode == :broadcast
        A_mul_B!(v, S, ones(n))
        return collect(zip(ns, v))
    elseif mode == :receive
        At_mul_B!(v, S, ones(n))
        return collect(zip(ns, v))
    else
        error("unknown mode $(mode)")
    end

end

