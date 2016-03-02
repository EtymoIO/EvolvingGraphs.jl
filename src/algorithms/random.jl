@doc doc"""
`random_time_graph(t, n [, p = 0.5; is_directed = true, 
has_self_loops = false])` generates a random time graph `g`.

Input:
     
     `t`: time 
     `n`: number of nodes
     `p`: the probability to include each edge (0.5 by default)
     `is_directed`: whether the graph is directed (`true` by default)
     `has_self_loops`: whether to include self loops (`false` by default)
"""->
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

@doc doc"""
`random_evolving_graph(nv, nt [, p = 0.5; is_directed = true, 
has_self_loops = false])` generate a random evolving graph `g`.

Input: 

    `nv`: number of nodes
    `nt`: number of timestamps
    `p`: the probability to include each edge (0.5 by default) 
    `is_directed`: whether the graph is directed (`true` by default)
    `has_self_loops`: whether to allow self loops (`false` by default).
"""->
function random_evolving_graph(nv::Int, 
                               nt::Int, 
                               p::Real = 0.5; 
                               is_directed = true,
                               has_self_loops  = false)
    g = int_evolving_graph(nv, nt, is_directed = is_directed)
    for t = 1:nt
        for i = 1:nv
            g.is_directed ? ind = 1 : ind = i
            
            for j = ind:nv
                if rand() <= p && (i != j || has_self_loops)
                    add_edge!(g, i, j, t)
                end
            end
        end
    end
    g
end
