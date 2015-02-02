#######################################
#
# tensor generation functions
#
######################################

function tensor_from_adjpairs!(a::AbstractMatrix, g::GenericEvolvingEdgeList, gen)
    if is_directed(g)
        for e in edges(g)
            u = source(e, g)
            v = target(e, g)
            t = time(e, g)
            ui = vertex_index(u, g)
            vi = vertex_index(v, g)
            ti = vertex_index(t, g)
            a[ui, vi, ti] = get(gen, g, u, v, t)
        end
    else
        for e in edges(g)
            u = source(e, g)
            v = target(e, g)
            t = time(e, g)
            ui = vertex_index(u, g)
            vi = vertex_index(v, g)
            ti = vertex_index(t, g)
            val = get(gen, g, u, v, t)
            a[ui, vi, ti] = val
            a[vi, ui, ti] = val
        end
    end

    return a
end

function tensor_from_adjpairs(g::EvolvingGraph, gen) 
    n = num_vertices(g)
    l = num_times(g)
    tensor_from_adjpairs!(zeros(eltype(gen), n, n, l), g, gen)
end    
  
type _GenUnit{T} end

Base.get{T,V}(::_GenUnit{T}, g::EvolvingGraph{V}, u::V, v::V) = one(T)
Base.eltype{T}(::_GenUnit{T}) = T

adjacency_tensor{T}(g::EvolvingGraph, ::Type{T}) = tensor_from_adjpairs(g, _GenUnit{T}())
