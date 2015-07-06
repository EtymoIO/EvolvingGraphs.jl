
typealias IntTuple2 (Int, Int) 

type IntEvolvingGraph <: AbstractEvolvingGraph{Int}
    is_directed::Bool
    nodes::Vector{IntTuple2}
    timestamps::Vector{Int}
    nedges::Int
    edges::Vector{TimeEdge{Int, Int}}
    adjlist::Dict{IntTuple2, Vector{IntTuple2}}
end

evolving_graph(;is_directed::Bool = true) = 
IntEvolvingGraph(is_directed, 
                 IntTuple2[],
                 Int[],
                 0,
                 TimeEdge{Int, Int}[],
                 Dict{IntTuple2, Vector{IntTuple2}}())

nodes(g::IntEvolvingGraph) = g.nodes
num_nodes(g::IntEvolvingGraph) = length(g.nodes)

num_edges(g::IntEvolvingGraph) = g.nedges
edges(g::IntEvolvingGraph) = g.edges

out_neighbors(g::IntEvolvingGraph, v::Tuple) = g.adjlist[v]
out_neighbors(g::IntEvolvingGraph, v, t) = out_neighbors(g, (int(v), int(t)))

has_node(g::IntEvolvingGraph, v::IntTuple2) = (v in g.nodes)

timestamps(g::IntEvolvingGraph) = g.timestamps

function add_node!(g::IntEvolvingGraph, v::IntTuple2)
    if !(v in g.nodes)
        push!(g.nodes, v)
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
        push!(g.edges, TimeEdge(v1[1], v2[1], v1[2]))
        if !(g.is_directed)
            push!(g.adjlist[v2], v1)
            push!(g.edges, TimeEdge(v2[1], v1[1], v1[2]))
        end
        g.nedges += 1
    end
    g
end

add_edge!(g::IntEvolvingGraph, v1::Int, v2::Int, t::Int) = add_edge!(g, (v1, t), (v2, t))
add_edge!(g::IntEvolvingGraph, te::TimeEdge{Int, Int}) = add_edge!(g, source(te), target(te), time(te))


function undirected!(g::IntEvolvingGraph) 
    es = edges(g)
    for e in es
        add_edge!(g, source(e), target(e), time(e))
    end
    g.is_directed = false
    g
end

copy(g::IntEvolvingGraph) = IntEvolvingGraph(g.is_directed, 
                                             g.nodes, 
                                             g.timestamps, 
                                             g.nedges, 
                                             g.edges, 
                                             g.adjlist)
            
