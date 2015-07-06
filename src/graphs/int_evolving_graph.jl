
typealias (Int, Int) IntTuple2

type IntEvolvingGraph <: AbstractEvolvingGraph
    is_directed::Bool
    nodes::Vector{IntTuple2}
    timestamps::Vector{Int}
    nedges::Int
    adjlist::Dict{IntTuple2, Vector{IntTuple2}}
end

evolving_graph(;is_directed::Bool = true) = 
IntEvolvingGraph(is_directed, 
                 IntTuple2[],
                 Int[],
                 0,
                 Dict{IntTuple2, Vector{IntTuple2}}())

nodes(g::IntEvolvingGraph) = g.nodes
num_nodes(g::IntEvolvingGraph) = length(g.nodes)

num_edges(g::IntEvolvingGraph) = g.nedges

out_neighbors(g::IntEvolvingGraph, v::IntTuple2) = g.adjlist[v]

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
    
    if !(v2 in g.adjlist[v1]) 
        push!(g.adjlist[v1], v2)
        if !(g.is_directed)
            v1 in g.ajlist[v2] || push!(g.adjlist[v2], v1)
        end
        g.nedges += 1
    end

    g
end

add_edge!(g::IntEvolvingGraph, v1::Int, v2::Int, t::Int) = add_edge!(g, (v1, t), (v2, t))
add_edge!(g::IntEvolvingGraph, te::TimeEdge{Int, Int}) = add_edge!(g, source(te), target(te), time(te))



            
