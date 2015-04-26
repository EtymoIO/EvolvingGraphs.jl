As = Matrix{Float64}[]
for i = 1:3
    push!(As, rand(3,3))
end

times = [1:3;]

g3 = time_tensor(times, As)

