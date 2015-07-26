####################################################
#
# Weighted EvolvingGraph type
#
#####################################################

type WeightedEvolvingGraph{V,T,W<:Real} <: AbstractEvolvingGraph{V,T,W}
    is_directed::Bool
    ilist::Vector{V}
    jlist::Vector{V}
    weights::Vector{W}
    timestamps::Vector{T} 
end

function weighted_evolving_graph{V,T,W}(ils::Vector{V}, 
                                        jls::Vector{V}, 
                                        ws::Vector{W},
                                        timestamps::Vector{T}; 
                                        is_directed::Bool = true)
    length(ils) == length(jls) == length(ws) == length(timestamps)|| 
                error("4 input vectors must have the same length.")
    return WeightedEvolvingGraph{V,T,W}(is_directed, ils, jls, ws, timestamps)
end

weighted_evolving_graph{V, T, W}(::Type{V}, 
                                 ::Type{W}, 
                                 ::Type{T}; 
                                 is_directed::Bool = true) = WeightedEvolvingGraph(is_directed, V[], V[], W[], T[])

weighted_evolving_graph(;is_directed::Bool = true) = weighted_evolving_graph(Int, FloatingPoint, Int, is_directed = is_directed)

is_directed(g::WeightedEvolvingGraph) = g.is_directed

function timestamps(g::WeightedEvolvingGraph)
    ts = unique(g.timestamps)
    if eltype(ts) <: Real
        ts = sort(ts)
    end
    return ts
end

num_timestamps(g::WeightedEvolvingGraph) = length(timestamps(g))

nodes(g::WeightedEvolvingGraph) = union(g.ilist, g.jlist)
num_nodes(g::WeightedEvolvingGraph) = length(nodes(g))

function edges(g::WeightedEvolvingGraph)
    n = length(g.ilist)

    edgelists = WeightedTimeEdge[]

    if g.is_directed
       for i = 1:n
           e = WeightedTimeEdge(g.ilist[i], g.jlist[i], g.weights[i], g.timestamps[i])
           push!(edgelists, e)
       end
    else
        for i = 1:n
            e1 = WeightedTimeEdge(g.ilist[i], g.jlist[i], g.weights[i], g.timestamps[i])
            e2 = WeightedTimeEdge(g.jlist[i], g.ilist[i], g.weights[i], g.timestamps[i])
            push!(edgelists, e1)
            push!(edgelists, e2)
        end
    end
    return edgelists
end

num_edges(g::WeightedEvolvingGraph) = g.is_directed ? length(g.ilist) : length(g.ilist)*2

# add a TimeEdge to an EvolvingGraph
function add_edge!(g::WeightedEvolvingGraph, te::WeightedTimeEdge)
    if !(te in edges(g))
        push!(g.ilist, te.source)
        push!(g.jlist, te.target)
        push!(g.weights, te.weight)
        push!(g.timestamps, te.timestamp)
    end
    g
end

function add_edge!{V, W<:Real, T}(g::WeightedEvolvingGraph, v1::V, v2::V, 
                                  w::W, t::T)
    add_edge!(g, WeightedTimeEdge(v1, v2, w, t))
end
