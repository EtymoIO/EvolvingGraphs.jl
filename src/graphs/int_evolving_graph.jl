
if VERSION < v"0.4-"
    typealias IntTuple2(Int, Int)
else
    typealias IntTuple2 Tuple{Int, Int}
end

typealias IntTimeEdge TimeEdge{Int, Int}


type IntEvolvingGraph <: AbstractEvolvingGraph{Int}
    is_directed::Bool
    nodes::Vector{IntTuple2}
    timestamps::Vector{Int}
    nedges::Int
    edges::Dict{Int, Vector{IntTimeEdge}}
    adjlist::Dict{IntTuple2, Vector{IntTuple2}}
end

evolving_graph(;is_directed::Bool = true) = 
IntEvolvingGraph(is_directed, 
                 IntTuple2[],
                 Int[],
                 0,
                 Dict{Int, Vector{IntTimeEdge}}(),
                 Dict{IntTuple2, Vector{IntTuple2}}())

nodes(g::IntEvolvingGraph) = unique(map(x -> x[1], g.nodes))
num_nodes(g::IntEvolvingGraph) = length(nodes(g))

num_edges(g::IntEvolvingGraph) = g.nedges

edges(g::IntEvolvingGraph, t::Int) = g.edges[t]
num_edges(g::IntEvolvingGraph, t::Int) = length(edges(g, t))

copy(g::IntEvolvingGraph) = IntEvolvingGraph(is_directed(g), 
                                             deepcopy(g.nodes), 
                                             deepcopy(g.timestamps), 
                                             deepcopy(g.nedges), 
                                             deepcopy(g.edges), 
                                             deepcopy(g.adjlist))


function edges(g::IntEvolvingGraph)
    elist = IntTimeEdge[]
    for t in timestamps(g)
        append!(elist, edges(g, t))
    end
    elist
end



function out_neighbors(g::IntEvolvingGraph, v::Tuple)
    try 
        return g.adjlist[v]
    catch KeyError
        return collect(zip([], []))
    end
end
out_neighbors(g::IntEvolvingGraph, v, t) = out_neighbors(g, (int(v), int(t)))

has_node(g::IntEvolvingGraph, v::IntTuple2) = (v in g.nodes)

timestamps(g::IntEvolvingGraph) = g.timestamps

function add_node!(g::IntEvolvingGraph, v::IntTuple2)
    if !(v in g.nodes)
        push!(g.nodes, v)
        if !(v[2] in keys(g.edges))
             g.edges[v[2]] = IntTimeEdge[]
        end
             
        g.adjlist[v] = IntTuple2[]
   
        if !(v[2] in g.timestamps)
            push!(g.timestamps, v[2])
            sort!(g.timestamps)
        end
    end
    v
end

function add_edge!(g::IntEvolvingGraph, v1::IntTuple2, v2::IntTuple2)
    v1[2] == v2[2] || error("Input nodes $(v1[1]) and $(v2[1]) must at the same timestamps")
    v1 in g.nodes || add_node!(g, v1)
    v2 in g.nodes || add_node!(g, v2)
    index = findin(map(x -> x[1], g.nodes), v1[1])
    for node in g.nodes[index]
        if node < v1
            v1 in g.adjlist[node] || push!(g.adjlist[node], v1)
        end
    end

    if !(v2 in g.adjlist[v1]) 
        push!(g.adjlist[v1], v2)
        push!(g.edges[v1[2]], TimeEdge(v1[1], v2[1], v1[2]))
        if !(g.is_directed)
            push!(g.adjlist[v2], v1)
            push!(g.edges[v1[2]], TimeEdge(v2[1], v1[1], v1[2]))
        end
        g.nedges += 1
    end
    g
end

add_edge!(g::IntEvolvingGraph, v1::Int, v2::Int, t::Int) = add_edge!(g, (v1, t), (v2, t))
add_edge!(g::IntEvolvingGraph, te::TimeEdge{Int, Int}) = add_edge!(g, source(te), target(te), time(te))


function undirected!(g::IntEvolvingGraph)
    for t in timestamps(g)
        for e in edges(g, t)
            add_edge!(g, target(e), source(e), time(e))
        end
    end
    g.is_directed = false
    g
end
            
function slice(g::IntEvolvingGraph, t1::Int, t2::Int)
    ts = timestamps(g)
    st = findfirst(ts, t1) 
    ed = findfirst(ts, t2)
    g1 = evolving_graph()
    for t in ts[st:ed]
        for te in edges(g, t)
            add_edge!(g1, te)
        end
    end
    g1
end

function spmatrix(g::IntEvolvingGraph, t::Int)
    es = edges(g, t)
    n = length(es)
    dim = maximum(nodes(g))
    is = Array(Int, n)
    js = Array(Int, n)
    vs = ones(Bool, n)
    for (i,e) in enumerate(es)
        is[i] = source(e)
        js[i] = target(e)
    end
    return sparse(is, js, vs, dim, dim)
end

function matrix(g::IntEvolvingGraph, t::Int)
    es = edges(g, t)
    dim = maximum(nodes(g))
    A = zeros(Bool, dim, dim)
    for e in es
        A[source(e), target(e)] = true
    end
    A
end
