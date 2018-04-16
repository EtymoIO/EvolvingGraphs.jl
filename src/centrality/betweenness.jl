

function betweenness(g::AbstractStaticGraph)
    A = sparse_adjacency_matrix(g)
    expA = expm(A)
    ns = nodes(g)
    for v in ns
        i = node_index(v)
        row = A[i,:]
        column = A[:, i]
        A[i,:] = 0
        A[:,i] = 0
        B = (expA - expm(A)) / expA
    end
end

function betweenness(g::AbstractEvolvingGraph)

end
