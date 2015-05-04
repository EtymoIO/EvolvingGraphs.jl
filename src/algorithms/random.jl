# build a random TimeGraph at time t,with n nodes 
# where each edge is included with probability p.
function random_time_graph{T}(t::T, 
                              n::Integer, 
                              p::Real = 0.5; 
                              is_directed = true,
                              has_self_loops = false)
    g = time_graph(Int, t, is_directed = is_directed)
    for i = 1:n
        g.is_directed ? ind = 1 : ind = i
        
        for j = ind:n
            add_node!(g, j)
            if rand() <= p && (i != j || has_self_loops)
                add_edge!(g, i, j)
            end
        end
    end
    return g
end

# build a random EvolvingGraph with nv nodes nt timestamps 
# where each edge is included with probability p.
function random_evolving_graph(nv::Int, 
                               nt::Int, 
                               p::Real = 0.5; 
                               is_directed = true,
                               has_self_loops  = false)
    g = evolving_graph(Int, Int, is_directed = is_directed)
    for i in 1:nt
        tg = random_time_graph(i, nv, p, is_directed=is_directed, has_self_loops = has_self_loops)
        add_graph!(g, tg)
    end
    return g
end
