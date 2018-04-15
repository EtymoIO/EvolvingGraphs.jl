"""

    random_graph(n,p=0.5, has_self_loops=false)

generate a random directed graph `g` with `n` nodes and the probability to include edge is `p`. If `has_self_loops`, `g` will include self loops.
"""
function random_graph(n::Integer, p::Real = 0.5; has_self_loops = false)
    g = DiGraph()
    for i = 1:n
        ind = 1
        for j = ind:n
            add_node!(g, j)
            if rand() <= p && (i != j || has_self_loops)
                add_edge!(g, i, j)
            end
        end
    end
    return g
end

"""
    random_evolving_graph(nv, nt, p=0.5, is_directed=true, has_self_loops=false)

Generate a random evolving graph `g` with `nv` nodes, `nt` timestamps. The probability to include each edge is equal to `p`. If `has_self_loops`,
we allow `g` to have self loops.
"""
function random_evolving_graph(g::IntAdjacencyList, nt::Int, p::Real = 0.5;
                               has_self_loops = false)
    nn = g.nnodes
    for t in 1:nt
        for i = 1:nn
            g.is_directed? ind =1 : ind = i
            for j = ind:nn
                    if (rand() <= p && (i != j || has_self_loops))
                        add_edge!(g, i, j, t)
                    end
            end
        end
    end
    g
end
function random_evolving_graph(nv::Int, nt::Int,p::Real = 0.5;
                               is_directed = true,has_self_loops  = false)
    g = IntAdjacencyList(nv, nt, is_directed = is_directed)
    random_evolving_graph(g, nt, p, has_self_loops = has_self_loops)
end
