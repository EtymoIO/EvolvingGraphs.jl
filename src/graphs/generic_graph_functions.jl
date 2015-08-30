
#####################################
#
# Graph functions
#
######################################

is_directed(g::AbstractGraph) = g.is_directed


#### Static Graph functions ####

@doc doc"""
`nodes(g)` returns the nodes of a static graph `g`.
"""->
nodes(g::AbstractStaticGraph) = g.nodes

@doc doc"""
`num_nodes(g)` returns the number of nodes of a static graph `g`.
"""->
num_nodes(g::AbstractStaticGraph) = length(g.nodes)

@doc doc"""
`num_edges(g)` returns the number of edges of a static graph `g`.
"""->
num_edges(g::AbstractStaticGraph) = g.nedges

@doc doc"""
`add_node!(g, v)` add a node `v` to a static graph `g`.
"""->
function add_node!{V<:NodeType}(g::AbstractStaticGraph{V}, v::V)
    if !(v in g.nodes)
        push!(g.nodes, v)
        g.adjlist[v] = V[]
    end
    v
end
add_node!(g::AbstractStaticGraph, v) = add_node!(g, make_node(g, v))

typealias EdgeType{V} Union(Edge{V}, TimeEdge{V}, WeightedTimeEdge{V},
                            AttributeTimeEdge{V})

@doc doc"""
`add_edge!(g, e)` adds an edge `e` to a static graph `g`. 
"""->
function add_edge!{V}(g::AbstractStaticGraph{V}, e::EdgeType{V})
    src = e.source
    dest = e.target
    if !(src in g.nodes)
        add_node!(g, src)
    end
    if !(dest in g.nodes)
        add_node!(g, dest)
    end

    if !(dest in g.adjlist[src])
        push!(g.adjlist[src], dest)    
        if !g.is_directed
            push!(g.adjlist[dest], src)
        end
        g.nedges += 1
    end
    return g
end

@doc doc"""
`add_edge!(g, i, j)` adds an edge from node `i` to node `j` to a static graph
`g`.
"""->
function add_edge!{V}(g::AbstractStaticGraph{V}, i::V, j::V)
    add_edge!(g, Edge(i,j))
end 

function add_edge!(g::AbstractStaticGraph, i, j) 
    n1 = add_node!(g, i)
    n2 = add_node!(g, j)
    add_edge!(g, n1, n2)
end

@doc doc"""
`out_neighbors(g, v)` returns a list of nodes that `v` points to on the
static graph `g`.
"""-> 
out_neighbors{V}(g::AbstractStaticGraph{V}, v::V) = g.adjlist[v]

@doc doc"""
`has_node(g, v)` returns `true` if `v` is a node of the static graph `g` 
and `false` otherwise.  
"""->
has_node{V}(g::AbstractStaticGraph{V}, v::V) = (v in g.nodes)


@doc doc"""
`matrix(g, T)` generates an adjacency matrix of type T of 
the static graph `g`. T = Bool by default.
"""->
function matrix{T<:Number}(g::AbstractStaticGraph, ::Type{T})
    ns = nodes(g)
    n = num_nodes(g)
    A = zeros(T, n, n)
    for (i,u) in enumerate(ns)
        for e in out_neighbors(g, u)
            j = findfirst(ns, e)
            A[(j-1)*n + i] = one(T)
        end
    end
    A
end

matrix(g::AbstractStaticGraph) = matrix(g, Bool)

#### Evolving Graph functions ####


@doc doc"""
`undirected!(g)` turns a directed graph to an undirected graph. 
"""->
undirected!(g::AbstractEvolvingGraph) = ( g.is_directed = false ; g)

@doc doc"""
`undirected(g)` turns a directed graph `g` to an undirected graph, leaving `g` unchanged.
"""->
undirected(g::AbstractEvolvingGraph) = undirected!(copy(g))

@doc doc"""
`has_node(g, v, t)` returns `true` if the node `v` at the timestamp `t` is 
in the evolving graph `g` and `false` otherwise. 
"""->
function has_node(g::AbstractEvolvingGraph, v, t)
    p = findin(g.timestamps , [t])
    return (v in g.ilist[p]) || (v in g.jlist[p]) 
end

@doc doc"""
`timestamps(g)` returns the timestamps of an evolving graph `g`.
"""->
function timestamps(g::AbstractEvolvingGraph) 
    ts = unique(g.timestamps)
    return sort(ts)
end

@doc doc"""
`num_timestamps(g)` returns the number of timestamps of `g`, 
where `g` is an evolving graph.
"""->
num_timestamps(g::AbstractEvolvingGraph) = length(timestamps(g))


@doc doc"""
`nodes(g)` returns the nodes of an evolving graph `g`. 
"""->
nodes(g::AbstractEvolvingGraph) = union(g.ilist, g.jlist)
num_nodes(g::AbstractEvolvingGraph) = length(nodes(g))

@doc doc"""
`out_neighbors(g, (v, t))` returns all the outward neightbors of the 
node `v` at timestamp `t` in the evolving graph `g`.
"""->
function out_neighbors(g::AbstractEvolvingGraph, v::Tuple)
    has_node(g, v[1], v[2]) || return collect(zip([], []))
    g = sorttime(g)
      
    starttime = findfirst(g.timestamps, v[2])
    endtime = findlast(g.timestamps, v[2])

    nodei = findin(g.ilist[starttime:end], [v[1]]) + starttime - 1
    nodej = findin(g.jlist[starttime:end], [v[1]]) + starttime - 1
    
    neighbors = sizehint!(Tuple[], length(nodei) + length(nodej))
    
    for i in nodei
        if i > endtime
            push!(neighbors, (g.ilist[i], g.timestamps[i]))
        else
            push!(neighbors, (g.jlist[i], g.timestamps[i]))
        end
    end
    for i in nodej
        if i > endtime
            push!(neighbors, (g.jlist[i], g.timestamps[i]))
        end
    end
    
    if !is_directed(g)
        for i in nodej
            if i <= endtime
                push!(neighbors, (g.ilist[i], g.timestamps[i]))
            end
        end
    end
            
    unique(neighbors)
end

out_neighbors(g::AbstractEvolvingGraph, v, t) = out_neighbors(g, (v,t))

function _find_edge_index(g::AbstractEvolvingGraph, te::EdgeType)
    tindx = findin(g.timestamps, [timestamp(te)])
    iindx = findin(g.ilist, [source(te)])
    jindx = findin(g.jlist, [target(te)])
    return intersect(tindx, iindx, jindx)[1]
end

_has_attribute(g::AbstractEvolvingGraph) = typeof(g) <: AttributeEvolvingGraph ? 
        true : false

typealias NodeVector{V} Vector{Node{V}}
