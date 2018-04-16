# simple adjacency list, which represents both nodes and timestamps as integers.

"""
    IntAdjacencyList(nv, nt)

Construct a graph represented by an adjacency list with `nv` nodes and `nt` timestamps, where both nodes and timestamps are represented by integers.


# Example

```jldoctest
julia> using EvolvingGraphs

julia> g = IntAdjacencyList(4,3)
Directed IntAdjacencyList (4 nodes, 0 static edges, 3 timestamps)

julia> add_edge!(g, 1, 2, 1)
Directed IntAdjacencyList (4 nodes, 1 static edges, 3 timestamps)

julia> add_edge!(g, 2, 3, 2)
Directed IntAdjacencyList (4 nodes, 2 static edges, 3 timestamps)

julia> num_edges(g)
2
```
"""
mutable struct IntAdjacencyList
    is_directed::Bool
    nodes::UnitRange{Int}
    timestamps::Vector{Int}
    nnodes::Int      # number of nodes
    nedges::Int      # number of static edges
    forward_adjlist::Vector{Vector{Int}}
    backward_adjlist::Vector{Vector{Int}}
end
function IntAdjacencyList(nv::Int, nt::Int; is_directed::Bool = true)
    ts = Array{Int}(nv*nt)
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
    IntAdjacencyList(is_directed, 1:nv*nt, ts, nv, 0, f_adj, b_adj)
end

is_directed(g::IntAdjacencyList) = g.is_directed

"""
    evolving_graph_to_adj(g)

Convert an evolving graph `g` to an adjacency list.

# Example

```jldoctest
julia> using EvolvingGraphs

julia> g = EvolvingGraph()
Directed EvolvingGraph 0 nodes, 0 static edges, 0 timestamps

julia> add_bunch_of_edges!(g, [(1,2,2001),(2,3,2002), (2,4,2002), (3,1,2003)])
Directed EvolvingGraph 4 nodes, 4 static edges, 3 timestamps

julia> evolving_graph_to_adj(g)
Directed IntAdjacencyList (4 nodes, 4 static edges, 3 timestamps)
```
"""
function evolving_graph_to_adj(g::AbstractEvolvingGraph)
    g1 = IntAdjacencyList(num_nodes(g), num_timestamps(g), is_directed = is_directed(g))

    tmap = Dict(t => i for (i, t) in enumerate(unique_timestamps(g)))
    for e in edges(g)
        v1 = node_index(source(e))
        v2 = node_index(target(e))
        add_edge!(g1, v1, v2, tmap[e.timestamp])
    end
    g1
end



nodes(g::IntAdjacencyList) = collect(1:g.nnodes)
num_nodes(g::IntAdjacencyList) = g.nnodes
num_edges(g::IntAdjacencyList) = g.nedges
timestamps(g::IntAdjacencyList) = g.timestamps
unique_timestamps(g::IntAdjacencyList) = unique(g.timestamps)
num_timestamps(g::IntAdjacencyList) = length(unique_timestamps(g))


deepcopy(g::IntAdjacencyList) = IntAdjacencyList(is_directed(g),
                                             deepcopy(g.nodes),
                                             deepcopy(g.timestamps),
                                             g.nnodes,
                                             g.nedges,
                                             deepcopy(g.forward_adjlist),
                                             deepcopy(g.backward_adjlist))




function forward_neighbors(g::IntAdjacencyList, v::Int, t::Int)
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
forward_neighbors(g::IntAdjacencyList, vt::Tuple{Int,Int}) = forward_neighbors(g, vt[1], vt[2])  

function add_edge!(g::IntAdjacencyList, v1::Int, v2::Int, t::Int)
    ns = g.nnodes
    n1 = v1 + ns*(t-1)
    n2 = v2 + ns*(t-1)
    if _insertnode!(g.forward_adjlist[n1], n2)
        g.nedges += 1

        for (v, n) in ((v1, n1), (v2, n2))
            for i in 1:t-1
                len = length(g.forward_adjlist[v + ns*(i-1)]) +
                length(g.backward_adjlist[v + ns*(i-1)])
                if len > 0
                    _insertnode!(g.forward_adjlist[v + ns*(i-1)], n)
                    _insertnode!(g.backward_adjlist[n], (v+ns*(i-1)))
                end
            end
            for i in t+1:num_timestamps(g)
                #   println("node: $(v + ns*(i-1))")
                len = length(g.forward_adjlist[v + ns*(i-1)]) +
                length(g.backward_adjlist[v + ns*(i-1)])
                if len > 0
                    _insertnode!(g.forward_adjlist[n], (v+ns*(i-1)))
                    _insertnode!(g.backward_adjlist[v+ns*(i-1)], n)
                end
            end
        end
    end
    _insertnode!(g.backward_adjlist[n2], n1)
    g
end

# The function _insertnode! is from LightGraphs.jl
# The LightGraphs.jl package is licensed under the Simplified "2-clause" BSD License:

#Copyright (c) 2015: Seth Bromberger and other contributors.

#Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

#Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# returns true if insert succeeded, false if it was a duplicate
_insertnode!(v::Vector{Int}, x::Int) = isempty(splice!(v, searchsorted(v,x), x))

# has_edge on active nodes
function _has_edge(g::IntAdjacencyList, n1::Int, n2::Int)
    nn = length(g.nodes)
    if n1 > nn || n2 > nn
        return false
    end
    return n2 in g.forward_adjlist[n1]
end


function has_edge(g::IntAdjacencyList, v1::Int, v2::Int, t::Int)
    ns = g.nnodes
    n1 = v1 + ns*(t-1)
    n2 = v2 + ns*(t-1)
    return _has_edge(g, n1, n2)
end
