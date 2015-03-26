
function adjacency_tensor(g::IntEvolvingGraph)
    n = num_nodes(g)
    k = num_timestamps(g)
    A = Array(Bool, n, n, k)
    if is_directed(g)
        for e in edges(g)
            ui = source(e, g)
            vi = target(e, g)
            ti = edge_time(e, g)
            A[ui, vi, ti] = true
        end
    else
        for e in edges(g)
            ui = source(e, g)
            vi = target(e, g)
            ti = edge_time(e, g)
            A[ui, vi, ti] = true
            A[vi, ui, ti] = true
        end
    end
    return A
end


#######################################
#
# tensor generation functions
#
######################################

function tensor_from_time_edge_list!{T}(a::Array{T, 3}, g::TimeEdgeList)
    if is_directed(g)
        for e in edges(g)
            u = source(e, g)
            v = target(e, g)
            t = edge_time(e, g)
            ui = node_index(u, g)
            vi = node_index(v, g)
            a[ui, vi, t] = one(T)
        end
    else
        for e in edges(g)
            u = source(e, g)
            v = target(e, g)
            t = time(e, g)
            ui = node_index(u, g)
            vi = node_index(v, g)
            a[ui, vi, t] = one(T)
            a[vi, ui, t] = one(T)
        end
    end

    return a
end

function adjacency_tensor{T}(::Type{T}, g::TimeEdgeList) 
    n = num_nodes(g)
    l = dim_times(g)
    tensor_from_time_edge_list!(zeros(T, n, n, l), g)
end    

adjacency_tensor(g::TimeEdgeList) = adjacency_tensor(Float64, g)
