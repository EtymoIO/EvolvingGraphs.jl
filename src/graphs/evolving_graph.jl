
# Graph type
# V:: Node type
# T:: Time type
#
type EvolvingGraph{V,T} <: AbstractEvolvingGraph{V,T}
    is_directed::Bool
    ilist::Vector{V}
    jlist::Vector{V}
    timestamps::Vector{T}
end



function evolving_graph{V,T}(ils::Vector{V}, jls::Vector{V}, timestamps::Vector{T}; is_directed::Bool=true)
    length(ils) == length(jls) == length(timestamps)|| error("3 input vectors must have the same length.")
    g = EvolvingGraph{V,T}(is_directed, ils, jls, timestamps)
    return g
end


is_directed(g::EvolvingGraph) = g.is_directed

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

num_edges(g::EvolvingGraph) = g.is_directed ? length(g.ilist) : length(g.ilist)*2
