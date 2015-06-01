
########################################
#
# AttributeEvolvingGraph type
#
########################################

type AttributeEvolvingGraph{V,T,W} <: AbstractEvolvingGraph{V,T,W}
    is_directed::Bool
    ilist::Vector{V}
    jlist::Vector{V}
    timestamps::Vector{T}
    attributesvec::Vector{W}
end

attribute_evolving_graph{V,T}(::Type{V}, 
                              ::Type{T}; 
                              is_directed::Bool = true) = AttributeEvolvingGraph(is_directed, V[], V[], T[], AttributeDict[])

is_directed(g::AttributeEvolvingGraph) = g.is_directed

function timestamps(g::AttributeEvolvingGraph)
    ts = unique(g.timestamps)
    if eltype(ts) <: Real
        ts = sort(ts)
    end
    return ts
end

num_timestamps(g::AttributeEvolvingGraph) = length(timestamps(g))

attributesvec(g::AttributeEvolvingGraph) = g.attributesvec


attributes(g::AttributeEvolvingGraph, e::AttributeTimeEdge) = e.attributes

nodes(g::AttributeEvolvingGraph) = union(g.ilist, g.jlist)
num_nodes(g::AttributeEvolvingGraph) = length(nodes(g))

function edges(g::AttributeEvolvingGraph)
    n = length(g.ilist)
    
    edgelist = AttributeTimeEdge[]

    if g.is_directed
        for i = 1:n
            e = AttributeTimeEdge(g.ilist[i], g.jlist[i], g.timestamps[i], g.attributesvec[i])
            push!(edgelist, e)
        end
    else
        for i = 1:n
            e1 = AttributeTimeEdge(g.ilist[i], g.jlist[i], g.timestamps[i], g.attributesvec[i])
            e2 = AttributeTimeEdge(g.jlist[i], g.ilist[i], g.timestamps[i], g.attributesvec[i])
            push!(edgelist, e1)
            push!(edgelist, e2)
        end
    end
    return edgelist            
end

function edges(g::AttributeEvolvingGraph, t)
    t in g.timestamps || error("unknown timestamp $(t)")

    n = length(g.ilist)
    
    edgelist = AttributeTimeEdge[]

    if g.is_directed
        for i = 1:n
            if t == g.timestamps[i]
                e = AttributeTimeEdge(g.ilist[i], g.jlist[i], g.timestamps[i], g.attributesvec[i])
                push!(edgelist, e)
            end
        end
    else
        for i = 1:n
            if t == g.timestamps[i]
                e1 = AttributeTimeEdge(g.ilist[i], g.jlist[i], g.timestamps[i], g.attributesvec[i])
                e2 = AttributeTimeEdge(g.jlist[i], g.ilist[i], g.timestamps[i], g.attributesvec[i])
                push!(edgelist, e1)
                push!(edgelist, e2)
            end
        end
    end
          
    edgelist

end

num_edges(g::AttributeEvolvingGraph) = g.is_directed ? length(g.ilist) : length(g.ilist)*2

function add_edge!(g::AttributeEvolvingGraph, te::AttributeTimeEdge)
    if !(te in edges(g))
        push!(g.ilist, te.source)
        push!(g.jlist, te.target)
        push!(g.timestamps, te.time)
        push!(g.attributesvec, te.attributes)
    end
    g
end

@doc doc"""
`matrix(g, t, attr = None)` returns an adjacency matrix representation
of an evolving graph `g` at time `t` with attribute `attr`.
"""->
function matrix(g::AttributeEvolvingGraph, t, attr = None)
    ns = nodes(g)
    n = num_nodes(g)
    es = edges(g, t)
 
    if attr == None
        A = zeros(Bool, n, n)
        for e in es
            i = find(x -> x == e.source, ns)
            j = find(x -> x == e.target, ns)
            A[(j-1)*n + i] = true
        end
    else
        A = zeros(Float64, n, n)
        for e in es
            i = find(x -> x == e.source, ns)
            j = find(x -> x == e.target, ns)
            A[(j-1)*n + i] = e.attributes[attr]
        end
    end
    A
end

@doc doc"""
`spmatrix(g, t, attr)` returns a sparse adjacency matrix representation 
of an evolving graph `g` at time `t` with attribute `attr`. 
"""->
function spmatrix(g::AttributeEvolvingGraph, t, attr = None)
    ns = nodes(g)
    n = num_nodes(g)
    is = Int[]
    js = Int[]
    es = edges(g, t)
    if attr == None
        for e in es
            i = find(x -> x == e.source, ns)
            j = find(x -> x == e.target, ns)
            append!(is, i)
            append!(js, j)
        end
        vs = ones(Bool, length(is))
        A = sparse(is, js, vs, n, n)
    else
        attrs = Float64[]
        for e in es
            i = find(x -> x == e.source, ns)
            j = find(x -> x == e.target, ns)
            append!(is, i)
            append!(js, j)
            push!(attrs, e.attributes[attr])
        end
        A = sparse(is, js, attrs, n, n)
    end
    A
end
