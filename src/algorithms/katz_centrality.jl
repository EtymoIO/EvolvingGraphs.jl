@doc doc"""
`katz_centrality(g [, α = 0.3, sorted = true])` computes the broadcast 
centrality vector of an evolving graph `g`. 

Input: 

     `g`: an evolving graph
     `α`: (= 0.3 default) a scalar the controls the influence of long walks. 
"""->
function katz_centrality(g::AbstractEvolvingGraph, α::Real = 0.3; sorted::Bool = true)
    n = num_nodes(g)
    ns = nodes(g)
    ts = timestamps(g)
    v = ones(Float64, n)
    A = spzeros(Float64, n, n)
    spI = speye(Float64, n)
    for t in ts
        A =  spmatrix(g,t)
        v = (spI - α*A)\v
        v =  v/norm(v)
    end
    rate = collect(zip(ns, v))
    if sorted
        return sort(rate, by = x-> x[2])
    else
        return rate
    end
end


@doc doc"""
`katz_centrality(g, α, β [, mode = :broadcast])` 
computes the Katz centrality of an evolving graph `g`. 

Input:

     `g`: an evolving graph
     `α`: a scalar that controls the influence of long walks
     `β`: a scalar that controls the influence of walks happened long time ago.
          `mode`: `mode = :broadcast` (default) generates the broadcast centrality 
          vector; `mode = :receive` generates the receving centrality vector; 
          `mode = :matrix` generates the communicability matrix.
"""->
function katz_centrality(g::AbstractEvolvingGraph, 
                         α::Real, 
                         β::Real;
                         mode::Symbol = :broadcast)
    n = num_nodes(g)
    ns = nodes(g)
    ts = timestamps(g) 
    S = spzeros(Float64, n, n)
    A = spzeros(Float64, n, n)
    spI = speye(Float64, n)
    v = Array{Float64}(n) 
    Δt = 1.
    for t in ts
        Δt += 0.01
        A =  spmatrix(g,t)
        S =  (spI + e^(-β*Δt)*S)*(spI + α*A) - spI
        S =  S/norm(S,1)
    end

    if mode == :matrix
        return S
    elseif mode == :broadcast
        v = S* ones(Float64, n)   
        return sort(collect(zip(ns, v)), by = x -> x[2])
    elseif mode == :receive
        v = S'*ones(Float64, n)
        return sort(collect(zip(ns, v)), by = x -> x[2])
    else
        throw(ArgumentError("unknown mode $(mode)"))
    end

end

