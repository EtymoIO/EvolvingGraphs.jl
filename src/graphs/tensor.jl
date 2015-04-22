# root
abstract AbstractTensor

###########################################
#
# TimeTensor type
#
###########################################

type TimeTensor{T, M} <: AbstractTensor
    is_directed::Bool
    times::Vector{T}
    matrices::Vector{Matrix{M}}
end

function time_tensor{T, M}(ts::Vector{T}, 
                           ms::Vector{Matrix{M}}; 
                           is_directed::Bool=true)
    length(ts) == length(ms) || 
             throw(ArgumentError("times and matrices must have the same length."))
    return TimeTensor(is_directed, ts, ms)
end

function time_tensor(g::IntEvolvingGraph)
    As = Matrix{Bool}[]
    n = num_nodes(g)
    A = zeros(Bool, n, n)
    times = unique(timestamps(g))
    if is_directed(g)
        for t in times
            for e in edges(g, t)
                ui = source(e, g)
                vi = target(e, g)
                A[ui, vi] = true
            end
            push!(As, A)
            A = zeros(Bool, n, n)            
        end
    else
        for t in times
            for e in edges(g, t)
                ui = source(e, g)
                vi = target(e, g)
                A[ui, vi] = true
                A[vi, ui] = true
            end
            push!(As, A)
            A = zeros(Bool, n, n)
        end
    end
    return time_tensor(times, As, is_directed = is_directed(g))
end

###########################################
#
# SparseTimeTensor type
#
###########################################

type SparseTimeTensor{T} <: AbstractTensor
    is_directed::Bool
    times::Vector{T}
    matrices::Vector{SparseMatrixCSC}
end

function sparse_time_tensor{T}(ts::Vector{T}, 
                           ms::Vector{SparseMatrixCSC}; 
                           is_directed::Bool=true)
    length(ts) == length(ms) || 
          throw(ArgumentError("times and matrices must have the same length."))
    return SparseTimeTensor(is_directed, ts, ms)
end


function sparse_time_tensor(g::IntEvolvingGraph)
    is_directed = g.is_directed
    times = unique(g.timestamps)
    num_mats =  length(times)
    min_nodes = minimum(nodes(g))
    ilist = g.ilist - min_nodes + 1  # normalize the nodes
    jlist = g.jlist - min_nodes + 1  # normalize the nodes
        
    symlabel = is_directed ? identity : Symmetric
   
    dim = num_nodes(g)
    As = Array(SparseMatrixCSC, num_mats)
    
    for (i,t) in enumerate(times)
        v = find(x -> x==t, g.timestamps)
        rr = ilist[v]
        cc = jlist[v]
        xx = ones(Bool, length(rr))
        As[i] = symlabel(sparse(rr,cc, xx, dim, dim))
    end
    return sparse_time_tensor(times, As, is_directed = is_directed)    
end


is_directed(g::AbstractTensor) = g.is_directed
timestamps(g::AbstractTensor) = g.times
num_timestamps(g::AbstractTensor) = length(g.times)

matrices(g::AbstractTensor) = g.matrices
num_matrices(g::AbstractTensor) = length(g.matrices)


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
