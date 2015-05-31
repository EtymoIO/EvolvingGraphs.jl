
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

