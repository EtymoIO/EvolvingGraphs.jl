# build a random graph of type TimeGraph
# with nodes are represented by integers
# Input: nn:: number of nodes
#        ne:: number of edges
function random_time_graph{T}(time::T, 
                              n::Integer, 
                              p::Real; 
                              is_directed = true,
                              has_self_loops = false)
    g = time_graph(Int, time, is_directed = is_directed)
    for i = 1:n
        start_ind = 1
        for j = start_ind:n
            add_node!(g, j)
            if rand() <= p && (i != j || has_self_loops)
                add_edge!(g, i, j)
            end
        end
    end
    return g
end
