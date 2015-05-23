
####################################################
#
# EvolvingGraph type
#
#####################################################

type EvolvingGraph{V,T} <: AbstractEvolvingGraph{V,T}
    is_directed::Bool
    ilist::Vector{V}
    jlist::Vector{V}
    timestamps::Vector{T} 
end

typealias IntEvolvingGraph EvolvingGraph{Int, Int}

@doc doc"""
evolving_graph(ils, jls, timestamps [, is_directed]) 
generates an evolving graph 

Input:

    `ils`: a vector of nodes
    `jls`: a vector of nodes 
    `timestamps`: a vector of timestamps
    `is_directed`: (optional) whether the graph is directed or not
"""->
function evolving_graph{V,T}(ils::Vector{V}, 
                             jls::Vector{V}, 
                             timestamps::Vector{T}; 
                             is_directed::Bool = true)
    length(ils) == length(jls) == length(timestamps)|| 
            error("3 input vectors must have the same length.")
    return EvolvingGraph{V,T}(is_directed, ils, jls, timestamps)    
end

@doc doc"""
evolving_graph([node_type, time_type, is_directed])
generates an evolving graph 

Input:

     `node_type`: type of the nodes
     `time_type`: type of the timestamps
     `is_directed`: whehter the graph is directed or not
"""->
evolving_graph{V,T}(::Type{V}, ::Type{T} ;is_directed::Bool = true) = EvolvingGraph(is_directed, V[], V[], T[])
evolving_graph(;is_directed::Bool = true) = evolving_graph(Int, Int, is_directed = is_directed)

@doc doc"""
is_directed(g) returns `true` if g is directed and `false` otherwise.
"""->
is_directed(g::EvolvingGraph) = g.is_directed

@doc doc"""
timestamps(g) returns the timestamps of an evolving graph g.
"""->
function timestamps(g::EvolvingGraph)
    ts = unique(g.timestamps)
    if eltype(ts) <: Real
        ts = sort(ts)
    end
    return ts
end

@doc doc"""
num_timestamps(g) returns the number of timestamps of g, 
where g is an evolving graph.
"""->
num_timestamps(g::EvolvingGraph) = length(timestamps(g))

@doc doc"""
nodes(g) return the nodes of an evolving graph g. 
"""->
nodes(g::EvolvingGraph) = union(g.ilist, g.jlist)
num_nodes(g::EvolvingGraph) = length(nodes(g))


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

# edge of an evolving graph at a given time
function edges{T}(g::EvolvingGraph, t::T)
    t in g.timestamps || error("unknown time stamp $(t)")

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

# add a TimeEdge to an EvolvingGraph
function add_edge!(g::EvolvingGraph, te::TimeEdge)
    if !(te in edges(g))
        push!(g.ilist, te.source)
        push!(g.jlist, te.target)
        push!(g.timestamps, te.time)
    end
    g
end

function add_edge!{V, T}(g::EvolvingGraph, v1::V, v2::V, t::T)
    add_edge!(g, TimeEdge(v1, v2, t))
end

# add a TimeGraph to an EvolvingGraph
function add_graph!(g::EvolvingGraph, tg::TimeGraph)
    t = time(tg)
    for v1 in nodes(tg)
        for v2 in out_neighbors(tg, v1)
            te = TimeEdge(v1, v2, t)
            if !(te in edges(g))
                add_edge!(g, te)
            end
        end
    end
    g
end


# get the adjacency matrix representation of an EvolvingGraph at a 
# specific time
function matrix(g::EvolvingGraph, t)
    ns = nodes(g)
    n = num_nodes(g)
    es = edges(g, t)
    A = zeros(Bool, n, n)
    for e in es
        i = find(x -> x == e.source, ns)
        j = find(x -> x == e.target, ns)
        A[(j-1)*n + i] = true
    end
    return A
end

function spmatrix(g::EvolvingGraph, t)
    ns = nodes(g)
    n = num_nodes(g)
    is = Int[]
    js = Int[]
    es = edges(g, t)
    for e in es
        i = find(x -> x == e.source, ns)
        j = find(x -> x == e.target, ns)
        append!(is, i)
        append!(js, j)
    end
    vs = ones(Bool, length(is))
    return sparse(is, js, vs, n, n)    
end

