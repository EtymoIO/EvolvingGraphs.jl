#######################################
#
# tensor generation functions
#
######################################

function tensor_from_adjpairs!(a::AbstractMatrix, g::EvolvingGraph, gen)
    if implements_edge_list(g)
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
    else
        error("g does not implement required interface.")
    end

    return a
end

function tensor_from_adjpairs(g::AbstractGraph, gen) 
    n = num_vertices(g)
    l = num_timesteps(g)
    tensor_from_adjpairs!(zeros(eltype(gen), n, n, l), g, gen)
end    
  


Base.get{T,V}(g::EvolvingGraph{V}, u::V, v::V) = one(T)
