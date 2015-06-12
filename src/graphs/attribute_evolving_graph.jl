
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
                              is_directed::Bool = true) = AttributeEvolvingGraph(is_directed, V[], V[], T[], Dict[])

attribute_evolving_graph(;is_directed::Bool = true) = attribute_evolving_graph(Int, Int, is_directed = is_directed)

is_directed(g::AttributeEvolvingGraph) = g.is_directed

function timestamps(g::AttributeEvolvingGraph)
    ts = unique(g.timestamps)
    return sort(ts)
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


@doc doc"""
`add_edge!(g, te) add an AttributeTimeEdge `te` to the graph `g`.
"""->
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
`add_edge!(g, v1, v2, t, a)` add an edge from `v1` to `v2` at time `t` 
with attribute `a` to the graph `g`, where attribute is a dictionary. 
For example, add_edge!(g, \"a\", \"b\", \"t\", Dict(\"friendship\" => 2.0))
"""->
function add_edge!(g::AttributeEvolvingGraph, v1, v2, t, a::Dict)
    te = AttributeTimeEdge(v1, v2, t, a)
    add_edge!(g, te)
    g
end


function add_edge!(g::AttributeEvolvingGraph, v1::Array, v2::Array, t, a::Dict)
    for j in v2
        for i in v1
            te = AttributeTimeEdge(i, j, t, a)
            add_edge!(g, te)
        end
    end
    g            
end

# to be documentated
function add_edge!(g::AttributeEvolvingGraph, v1, v2, t)
    te = AttributeTimeEdge(v1, v2, t)
    add_edge!(g, te)
    g
end

has_edge(g::AttributeEvolvingGraph, te::AttributeTimeEdge) = te in edges(g)
has_edge(g::AttributeEvolvingGraph, v1, v2, t) = has_edge(g, AttributeTimeEdge(v1, v2, t))

function rm_edge!(g::AttributeEvolvingGraph, te::AttributeTimeEdge)
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
    splice!(g.attributesvec, i)
    g
end

rm_edge!(g::AttributeEvolvingGraph, v1, v2, t) = rm_edge!(g, AttributeTimeEdge(v1, v2, t))


@doc doc"""
`matrix(g, t, attr = None)` returns an adjacency matrix representation
of an evolving graph `g` at time `t`. If `attr` is present, return a 
weighted adjacency matrix where the edge weight is given by the attribute
`attr`.
"""->
function matrix(g::AttributeEvolvingGraph, t, attr = None)
    ns = nodes(g)
    n = num_nodes(g)
    es = edges(g, t)
 
    if attr == None
        A = zeros(Bool, n, n)
        for e in es
            i = findfirst(ns, e.source)
            j = findfirst(ns, e.target)
            A[(j-1)*n + i] = true
        end
    else
        A = zeros(Float64, n, n)

        for e in es
            i = findfirst(ns, e.source)
            j = findfirst(ns, e.target)
      
            A[(j-1)*n + i] = float(e.attributes[attr])
        end
    end
    A
end

@doc doc"""
`spmatrix(g, t, attr)` returns a sparse adjacency matrix representation 
of an evolving graph `g` at time `t`. If `attr` is present, return a 
weighted adjacency matrix where the edge weight is given by the attribute
`attr`. 
"""->
function spmatrix(g::AttributeEvolvingGraph, t, attr = None)
    ns = nodes(g)
    n = num_nodes(g)
    is = Int[]
    js = Int[]
    es = edges(g, t)
    if attr == None
        for e in es
            i = findfirst(ns, e.source)
            j = findfirst(ns, e.target)
            push!(is, i)
            push!(js, j)
        end
        vs = ones(Bool, length(is))
        A = sparse(is, js, vs, n, n)
    else
        attrs = Float64[]
        for e in es
            i = findfirst(ns, e.source)
            j = findfirst(ns, e.target)
            push!(is, i)
            push!(js, j)
 
            push!(attrs, float(e.attributes[attr]))
        end
        A = sparse(is, js, attrs, n, n)
    end
    A
end
