
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

deepcopy(g::EvolvingGraph) = EvolvingGraph(is_directed(g), 
                                           deepcopy(g.ilist),
                                           deepcopy(g.jlist), 
                                           deepcopy(g.timestamps))

"""
    undirected!(g)

Change a directed evolving graph g to an undirected evolving graph.
"""
undirected!(g::EvolvingGraph) = ( g.is_directed = false ; g)

"""
    undirected(g)

Make a copy of g and change it to an undirected evolving graph.
"""
undirected(g::EvolvingGraph) = undirected!(deepcopy(g))

###### nodes ##############################################

"""
    has_node(g, v, t)

Return `true` if `(v,t)` is an active node of `g` and `false` otherwise.
"""
function has_node(g::EvolvingGraph, v, t)
    p = findin(g.timestamps , [t])
    return (v in g.ilist[p]) || (v in g.jlist[p]) 
end

"""
    has_node(g, v)

Return `true` if  `v` is a node of `g`.
"""
has_node(g::EvolvingGraph, v) = (v in g.ilist || v in g.jlist)

"""
    nodes(g)

Return the nodes of the evolving graph `g`.
"""
nodes(g::EvolvingGraph) = union(g.ilist, g.jlist)
num_nodes(g::EvolvingGraph) = length(nodes(g))

function timestamps(g::EvolvingGraph) 
    ts = unique(g.timestamps)
    return sort(ts)
end
num_timestamps(g::EvolvingGraph) = length(timestamps(g))

eltype(g::EvolvingGraph) = (eltype(g.ilist), eltype(g.timestamps))

"""
    edges(g)

Return the edges of g in type TimeEdge.
"""
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


"""
    edges(g, t)

Return the edges of an evolving graph `g` at a given timestamp `t`.
"""
function edges(g::EvolvingGraph, t)
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


"""
    num_edges(g)

Return the number of edges of an evolving graph `g`.
"""
num_edges(g::EvolvingGraph) = g.is_directed ? length(g.ilist) : length(g.ilist)*2


"""
    add_edge!(g, te)

Add a TimeEdge `te` to an evolving graph `g`.
"""
function add_edge!(g::EvolvingGraph, te::TimeEdge)
    if !(te in edges(g))
        push!(g.ilist, te.source)
        push!(g.jlist, te.target)
        push!(g.timestamps, te.timestamp)
    end
    g
end


"""
    add_edge!(g, v1, v2, t)

Add an edge from `v1` to `v2` at time `t` to an evolving graph `g`.
"""
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

"""
    has_edge(g, v1, v2, t)

Return `true` if `g` has an edge from `v1` to `v2` at time `t` and `false` otherwise. 
"""
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

"""
    rm_edge!(g, v1, v2, t) 

Remove an edge from `v1` to `v2` at time `t` from `g`. 
"""
rm_edge!(g::EvolvingGraph, v1, v2, t) = rm_edge!(g, TimeEdge(v1, v2, t))

"""
    add_graph!(g, tg)

Add a TimeGraph `tg` to an evolving graph `g`.
"""
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


"""
    matrix(g, t)

Return an adjacency matrix representation of an evolving graph `g` at timestamp `t`.
"""
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


"""
    spmatrix(g, t)

Return a sparse adjacency matrix representation of an evolving graph
`g` at timestamp `t`.
"""
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
