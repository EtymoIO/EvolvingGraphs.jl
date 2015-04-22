
# test EvolvingGraph type
a = [1,2,2,3,4,4,5];
b = [2,3,3,4,6,2,1];
times = [1.:7;];

g = evolving_graph(a, b, times)
@test num_nodes(g) == 6
@test_approx_eq norm(nodes(g) - [1:6;]) 0
@test num_edges(g) == 7
edges(g)

g2 = evolving_graph(a, b, times, is_directed = false)
@test num_nodes(g2) == 6
@test num_edges(g2) == 14
edges(g2)

println("EvolvingGraph type passed test...")

######################################################

As = Matrix{Float64}[]
for i = 1:3
    push!(As, rand(3,3))
end

times = [1:3;]

g3 = time_tensor(times, As)

println("TimeTensor type passed test...")

#####################################################

g4 = build_evolving_graph()
s1 = sparse_time_tensor(g4)

s3 = build_sparse_tensor()

println("SparseTimeTensor type passed test...")
