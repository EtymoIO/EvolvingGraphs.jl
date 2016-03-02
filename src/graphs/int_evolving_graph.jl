export int_evolving_graph, temporal_nodes


type IntEvolvingGraph <: AbstractEvolvingGraph
    is_directed::Bool
    nodes::UnitRange{Int}
    timestamps::Vector{Int}
    nnodes::Int      # number of nodes
    nedges::Int      # number of edges
    forward_adjlist::Vector{Vector{Int}}
    backward_adjlist::Vector{Vector{Int}}
end

"""
   int_evolving_graph(nv, nt; is_directed)

Initialize an evolving graph with `nv` nodes and `nt` timestamps
"""
function int_evolving_graph(nv::Int, nt::Int; is_directed::Bool = true)
    ts = Array(Int, nv*nt)
    f_adj = Vector{Int}[]
    b_adj = Vector{Int}[]
    for i = 1:nv*nt
        push!(f_adj, Int[])
        push!(b_adj, Int[])
    end
    for t = 1:nt
        for v = 1:nv
            ts[v + nv*(t-1)] = t
        end
    end
    IntEvolvingGraph(is_directed, 1:nv*nt, ts, nv, 0, f_adj, b_adj)
end

"""
    int_evolving_graph(g)

Convert an EvolvingGraph to an IntEvolvingGraph.
"""
function int_evolving_graph(g::EvolvingGraph) 
    g1 = int_evolving_graph(is_directed = is_directed(g))
    for e in edges(g)
        add_edge!(g1, e)
    end
    g1
end

# all active nodes of g 
function temporal_nodes(g::IntEvolvingGraph)
    ns = Array(Tuple{Int, Int}, length(g.nodes))
    b = g.nnodes
    for i in g.nodes
        t = g.timestamps[i]
        ns[i] = (i - b*(t-1), t)
    end
    ns
end
nodes(g::IntEvolvingGraph) = 1:g.nnodes
num_nodes(g::IntEvolvingGraph) = g.nnodes
num_edges(g::IntEvolvingGraph) = g.nedges
timestamps(g::IntEvolvingGraph) = unique(g.timestamps)
num_timestamps(g::IntEvolvingGraph) = round(Int, length(g.timestamps)/g.nnodes)
num_edges(g::IntEvolvingGraph, t::Int) = g.nedges

copy(g::IntEvolvingGraph) = IntEvolvingGraph(is_directed(g), 
                                             deepcopy(g.nodes), 
                                             deepcopy(g.timestamps), 
                                             g.nnodes,
                                             g.nedges, 
                                             deepcopy(g.forward_adjlist))



function forward_neighbors(g::IntEvolvingGraph, v::Int, t::Int)
    ns = g.nnodes
    n = v + ns*(t-1)
    nn = Tuple{Int, Int}[]
    for node in g.forward_adjlist[n]
        t = g.timestamps[node]
        v1 = node - ns*(t-1)
        push!(nn, (v1, t))
    end
    nn
end
forward_neighbors(g::IntEvolvingGraph, v::Tuple) = forward_neighbors(g, v[1], v[2])


function add_edge!(g::IntEvolvingGraph, v1::Int, v2::Int, t::Int)
    ns = g.nnodes
    n1 = v1 + ns*(t-1)
    n2 = v2 + ns*(t-1)
    if n2 in g.forward_adjlist[n1]
        error("$(n2) is already in the forward neighbors.")
    else
        push!(g.forward_adjlist[n1], n2)
    end
    if n1 in g.backward_adjlist[n2]
        error("$(n1) is already in the backward neighbors")
    else
        push!(g.backward_adjlist[n2], n1)
    end
    g.nedges += 1
    for (v, n) in ((v1, n1), (v2, n2))
        for i in 1:t-1
            len = length(g.forward_adjlist[v + ns*(i-1)]) + 
            length(g.backward_adjlist[v + ns*(i-1)])       
            if len > 0
                n in g.forward_adjlist[v + ns*(i-1)] || push!(g.forward_adjlist[v + ns*(i-1)], n) 
                (v + ns*(i-1)) in g.backward_adjlist[n] || push!(g.backward_adjlist[n], v + ns*(i-1))
            end
        end
        #for i in t+1:num_timestamps(g)
         #   println("node: $(v + ns*(i-1))")
          #  len = length(g.forward_adjlist[v + ns*(i-1)]) + 
          #  length(g.backward_adjlist[v + ns*(i-1)])
          #  if len > 0
           #     push!(g.forward_adjlist[n], v+ ns*(i-1))
           #     push!(g.backward_adjlist[v + ns*(i-1)], n)
           # end
       # end
    end
    g
end
