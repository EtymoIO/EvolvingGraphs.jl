
####################################################
#
# EvolvingGraph type
#
#####################################################

type EvolvingGraph{V,T} <: AbstractEvolvingGraph{V, Edge{V}, T}
    is_directed::Bool
    ilist::Vector{V}
    jlist::Vector{V}
    timestamps::Vector{T} 
end


"""
    evolving_graph(ils, jls, timestamps[, is_directed = true]) 

Generate an evolving graph from three input vectors: ils, jls and timestamps, such that
the ith entry `(ils[i], jls[i] and timestamps[i])` is an edge from `ils[i]` to `jls[i]` at timestamp
`timestamp[i]`.
"""
function evolving_graph{V,T}(ils::Vector{V}, 
                             jls::Vector{V}, 
                             timestamps::Vector{T}; 
                             is_directed::Bool = true)
    length(ils) == length(jls) == length(timestamps)|| 
            error("3 input vectors must have the same length.")
    return EvolvingGraph(is_directed, ils, jls, timestamps)    
end

"""
    evolving_graph([node_type, time_type[, is_directed = true])

Initialize an evolving graph where the nodes are of type `node_type` and 
the timestamps are of type `time_type`.
"""
evolving_graph{V,T}(::Type{V}, ::Type{T} ;is_directed::Bool = true) = EvolvingGraph(is_directed, V[], V[], T[])

"""
    evolving_graph([is_directed = true])

Initialize an evolving graph with integer nodes and timestamps.
"""
evolving_graph(;is_directed::Bool = true) = evolving_graph(Int, Int, is_directed = is_directed)

copy(g::EvolvingGraph) = EvolvingGraph(is_directed(g), 
                                       deepcopy(g.ilist),
                                       deepcopy(g.jlist), 
                                       deepcopy(g.timestamps))


@doc doc"""
`edges(g)` return the edges of an evolving graph `g`.
"""->
function edges(g::EvolvingGraph)
    n = length(g.ilist)

    edgelists = TimeEdge[]

    if g.is_directed
       for i = 1:n
           e = TimeEdge(g.ilist[i], g.jlist[i], g.timestamps[i])
           push!(edgelists, e)
       end
    else
        for i = 1:n
            e1 = TimeEdge(g.ilist[i], g.jlist[i], g.timestamps[i])
            e2 = TimeEdge(g.jlist[i], g.ilist[i], g.timestamps[i])
            push!(edgelists, e1)
            push!(edgelists, e2)
        end
    end
    return edgelists
end


@doc doc"""
`edges(g, t)` return the edges of an evolving graph `g` at a given timestamp `t`.
"""->
function edges{T}(g::EvolvingGraph, t::T)
    t in g.timestamps || error("unknown timestamp $(t)")

    n = length(g.ilist)
    
    edgelists = TimeEdge[]
  
    if g.is_directed
        for i = 1:n
            if t == g.timestamps[i]
                e = TimeEdge(g.ilist[i], g.jlist[i], g.timestamps[i])
                push!(edgelists, e)
            end
        end
    else
        for i = 1:n
            if t == g.timestamps[i]
                e1 = TimeEdge(g.ilist[i], g.jlist[i], g.timestamps[i])
                e2 = TimeEdge(g.jlist[i], g.ilist[i], g.timestamps[i])
                push!(edgelists, e1)
                push!(edgelists, e2)
            end
        end
    end
          
    return edgelists
end


@doc doc"""
`num_edges(g)` returns the number of edges of an evolving graph `g`.
"""->
num_edges(g::EvolvingGraph) = g.is_directed ? length(g.ilist) : length(g.ilist)*2

# reduce the number of timestamps by emerging the graph with less
# than n edges to a neighbour graph
function reduce_timestamps!(g::EvolvingGraph, n::Int = 2)
    times = timestamps(g)    
    
    for (i,t) in enumerate(times)
        v = find(x -> x == t, g.timestamps)
        if length(v) >= n
            continue
        end
        try 
            [g.timestamps[j] = times[i+1] for j in v] 
        catch BoundsError
        end
    end
    g
end 


@doc doc"""
`add_edge!(g, te)` adds a time edge `te` to an evolving graph `g`.
"""->
function add_edge!(g::EvolvingGraph, te::TimeEdge)
    if !(te in edges(g))
        push!(g.ilist, te.source)
        push!(g.jlist, te.target)
        push!(g.timestamps, te.timestamp)
    end
    g
end


@doc doc"""
`add_edge!(g, v1, v2, t)` adds an edge from `v1` to `v2` at time `t` 
to an evolving graph `g`.
"""->
function add_edge!(g::EvolvingGraph, v1, v2, t)
    add_edge!(g, TimeEdge(v1, v2, t))
    g
end

function add_edge!(g::EvolvingGraph, v1::Array, v2::Array, t)
    for j in v2
        for i in v1
            te = TimeEdge(i, j, t)
            add_edge!(g, te)
        end
    end
    g
end



has_edge(g::EvolvingGraph, te::TimeEdge) = te in edges(g)

@doc doc"""
`has_edge(g, v1, v2, t)` returns `true` if the edge from `v1` to `v2` 
at time `t` is in graph `g` and false otherwise. 
"""->
has_edge(g::EvolvingGraph, v1, v2, t) = has_edge(g, TimeEdge(v1, v2, t))

function rm_edge!(g::EvolvingGraph, te::TimeEdge)
    has_edge(g, te) || error("$(te) is not in the graph.")
    i = 0
    try 
        i = _find_edge_index(g, te)
    catch
        i = _find_edge_index(g, rev(te))
    end
    
    splice!(g.ilist, i)
    splice!(g.jlist, i)
    splice!(g.timestamps, i)
    g
end

@doc doc"""
`rm_edge!(g, v1, v2, t)` removes an edge from `v1` to `v2` at time `t`
from an evolving graph `g`. 
"""->
rm_edge!(g::EvolvingGraph, v1, v2, t) = rm_edge!(g, TimeEdge(v1, v2, t))

@doc doc"""
`add_graph!(g, tg)` adds a time graph `tg` to an evolving graph `g`.
"""->
function add_graph!(g::EvolvingGraph, tg::TimeGraph)
    t = timestamp(tg)
    is = eltype(g.ilist)[]
    js = eltype(g.jlist)[]
    ts = eltype(g.timestamps)[]
    for v1 in nodes(tg)
        for v2 in forward_neighbors(tg, v1)
            push!(is, v1.key)
            push!(js, v2.key)
            push!(ts, t)
        end
    end
    append!(g.ilist, is)
    append!(g.jlist, js)
    append!(g.timestamps, ts)
    g
end


@doc doc"""
`matrix(g, t)` returns an adjacency matrix representation of
 an evolving graph `g` at timestamp `t`.
"""->
function matrix(g::EvolvingGraph, t)
    ns = nodes(g)
    n = num_nodes(g)
    es = edges(g, t)
    A = zeros(Bool, n, n)
    for e in es
        i = findfirst(ns, e.source)
        j = findfirst(ns, e.target)
        A[(j-1)*n + i] = true
    end
    return A
end


@doc doc"""
`spmatrix(g, t)` returns a sparse adjacency matrix representation of 
an evolving graph `g` at timestamp `t`.
"""->
function spmatrix(g::EvolvingGraph, t)
    ns = nodes(g)
    n = num_nodes(g)
    is = Int[]
    js = Int[]
    es = edges(g, t)
    for e in es
        i = findfirst(ns, e.source)
        j = findfirst(ns, e.target)
        push!(is, i)
        push!(js, j)
    end
    vs = ones(Bool, length(is))
    return sparse(is, js, vs, n, n)    
end
