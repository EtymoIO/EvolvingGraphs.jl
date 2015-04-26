
####################################################
#
# EvolvingGraph type
#
#####################################################

type EvolvingGraph{V,T} <: AbstractEvolvingGraph{V, TimeEdge, T}
    is_directed::Bool
    ilist::Vector{V}
    jlist::Vector{V}
    timestamps::Vector{T} 
end

typealias IntEvolvingGraph EvolvingGraph{Int, Int}

function evolving_graph{V,T}(ils::Vector{V}, 
                             jls::Vector{V}, 
                             timestamps::Vector{T}; 
                             is_directed::Bool = true)
    length(ils) == length(jls) == length(timestamps)|| 
            error("3 input vectors must have the same length.")
    return EvolvingGraph{V,T}(is_directed, ils, jls, timestamps)    
end

evolving_graph(;is_directed::Bool = true) = EvolvingGraph(is_directed, [], [], [])


is_directed(g::EvolvingGraph) = g.is_directed

function timestamps(g::EvolvingGraph)
    ts = unique(g.timestamps)
    if eltype(ts) <: Real
        ts = sort(ts)
    end
    return ts
end

num_timestamps(g::EvolvingGraph) = length(timestamps(g))

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

# merge two EvolvingGraph type objects
function merge(g1::EvolvingGraph, g2::EvolvingGraph)
    g1.is_directed == g2.is_directed || 
               error("one EvolvingGraph is directed, while the other is undiredted ")
    eltype(g1.ilist) == eltype(g2.ilist) && eltype(g1.timestamps) == eltype(g2.timestamps) ||
               error("the type of input graphs must agree.")
    newilist = cat(1, g1.ilist, g2.ilist) # ?append ?merge
    newjlist = cat(1, g1.jlist, g2.jlist)
    newtimestamps = cat(1, g1.timestamps, g2.timestamps)
    return EvolvingGraph(g1.is_directed, newilist, newjlist, newtimestamps)               
end

####################################################
#
# Weighted EvolvingGraph type
#
#####################################################

type WeightedEvolvingGraph{V,W,T} <: AbstractEvolvingGraph{V, TimeEdge, T}
    is_directed::Bool
    ilist::Vector{V}
    jlist::Vector{V}
    weights::Vector{W}
    timestamps::Vector{T} 
end
