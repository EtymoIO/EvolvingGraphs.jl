
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
                             is_directed::Bool=true)
    length(ils) == length(jls) == length(timestamps)|| 
            error("3 input vectors must have the same length.")
    return EvolvingGraph{V,T}(is_directed, ils, jls, timestamps)    
end


is_directed(g::EvolvingGraph) = g.is_directed
timestamps(g::EvolvingGraph) = unique(g.timestamps)
num_timestamps(g::EvolvingGraph) = length(timestamps(g))

nodes(g::EvolvingGraph) = union(g.ilist, g.jlist)
num_nodes(g::EvolvingGraph) = length(nodes(g))


function edges(g::EvolvingGraph)
    n = length(g.ilist)

    edgelists = TimeEdge[]

    for i = 1:n
        e = TimeEdge(g.ilist[i], g.jlist[i], g.timestamps[i])
        push!(edgelists, e)
    end
    if !(g.is_directed)
        for i = 1:n
            e = TimeEdge(g.jlist[i], g.ilist[i], g.timestamps[i])
            push!(edgelists, e)
        end
    end
    return edgelists
end

# edge of an evolving graph at a given time
function edges{T}(g::EvolvingGraph, t::T)
    t in g.timestamps || error("unknown time stamp $(t)")

    n = length(g.ilist)
    
    edgelists = TimeEdge[]
            
    for i = 1:n
        if t == g.timestamps[i]
            e = TimeEdge(g.ilist[i], g.jlist[i], g.timestamps[i])
            push!(edgelists, e)
            if !(g.is_directed)
                e2 = TimeEdge(g.jlist[i], g.ilist[i], g.timestamps[i])
                push!(edgelists, e2)
            end
        end
    end
    return edgelists
end

num_edges(g::EvolvingGraph) = g.is_directed ? length(g.ilist) : length(g.ilist)*2

# 
function slicing!(g::EvolvingGraph, t::Int)
    
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
