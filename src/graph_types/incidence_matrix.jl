export IncidenceList
export incidence_list

if VERSION < v"0.5.0-dev+961"
    IncidenceVector = AbstractVector
else
    IncidenceVector = SparseVector
end

type IncidenceList
    nnodes::Int         # number of nodes
    ntimestamps::Int   # number of timestamps
    edges::Vector{IncidenceVector{Int}}
end

nodes(g::IncidenceList) = collect(1:g.nnodes)
num_nodes(g::IncidenceList) = g.nnodes
timestamps(g::IncidenceList) = collect(1:g.ntimestamps)
num_timestamps(g::IncidenceList) = g.ntimestamps
function edges(g::IncidenceList)
    nn = g.nnodes
    edges = g.edges
    elists = Tuple{Int, Int, Int}[]
    for e in edges
        if VERSION < v"0.5.0-dev+961"
            v1, v2 = findn(e)
        else
            v1, v2 = e.nzind
        end
        i = mod(v1, nn)
        j = mod(v2, nn)
        t = round(Int, (v1-i)/nn + 1)  
        push!(elists, (i,j,t)) # (i,j,t) node i to node j at time stamp t
    end
    elists
end

"""
`incidence_list(n)`

Create an incidence matrix with `n` nodes
"""
incidence_list(n::Int) = IncidenceList(n, 1, IncidenceVector{Int}[])

"""
`add_edge!(g, i, j, t)`

Add an edge from `i` to `j` at time stamp `t` to an evolving graph `g`.
"""
function add_edge!(g::IncidenceList, i::Int, j::Int, t::Int)
    nn = g.nnodes
    nt = g.ntimestamps
    if t > nt
        g.ntimestamps = t
    end
    i = i + (t-1)*nn
    j = j + (t-1)*nn
    i <= t*nn && j <= t*nn || throw(DimensionMismatch(""))
    if VERSION < v"0.5.0-dev+961"
        v = zeros(Int, t*nn)
        v[i] = one(Int); v[j] = one(Int)
        push!(g.edges, v)
    else
        push!(g.edges, sparsevec([i,j], [1,1], t*nn))
    end
    g
end
