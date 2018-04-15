"""
    AdjacencyList{V,T}(nv, nt)
    AdjacencyList(nv, nt)

Construct a graph represented by adjacency list with `nv` nodes and `nt` timestamps, where `V` and `T` are the type of nodes and timestamps respectively. `AdjacencyList(nv, nt)` constructs an adjacency list with integer numbers of and timestamps.
"""
mutable struct AdjacencyList{V,T} <: AbstractGraph{V,T}
    is_directed::Bool
    nodes::UnitRange{V}
    timestamps::Vector{T}
    nnodes::Int      # number of nodes
    nedges::Int      # number of static edges
    forward_adjlist::Vector{Vector{V}}
    backward_adjlist::Vector{Vector{V}}
end
function AdjacencyList{V,T}(nv::Int, nt::Int; is_directed::Bool = true) where V where T
    ts = Array{T}(nv*nt)
    f_adj = Vector{V}[]
    b_adj = Vector{V}[]
    for i = 1:nv*nt
        push!(f_adj, V[])
        push!(b_adj, V[])
    end
    for t = 1:nt
        for v = 1:nv
            ts[v + nv*(t-1)] = t
        end
    end
    AdjacencyList(is_directed, 1:nv*nt, ts, nv, 0, f_adj, b_adj)
end
function AdjacencyList(nv::Int, nt::Int; is_directed::Bool = true)
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
    AdjacencyList(is_directed, 1:nv*nt, ts, nv, 0, f_adj, b_adj)
end

"""
    evolving_graph_to_adj(g)

Convert an evolving graph `g` to an adjacency list.
"""
function evolving_graph_to_adj(g::AbstractEvolvingGraph)
    g1 = AdjacencyList(num_nodes(g), num_timestamps(g),
                                             is_directed = is_directed(g))
    for e in edges(g)
        v1 = node_index(source(e))
        v2 = node_index(target(e))
        add_edge!(g1, v1, v2, e.timestamp)
    end
    g1
end


function active_nodes(g::AdjacencyList)
    ns = Array(Tuple{Int, Int}, length(g.nodes))
    b = g.nnodes
    for i in g.nodes
        t = g.timestamps[i]
        ns[i] = (i - b*(t-1), t)
    end
    ns
end

nodes(g::AdjacencyList) = collect(1:g.nnodes)
num_nodes(g::AdjacencyList) = g.nnodes
num_edges(g::AdjacencyList) = g.nedges
timestamps(g::AdjacencyList) = unique(g.timestamps)
num_timestamps(g::AdjacencyList) = round(Int, length(g.timestamps)/g.nnodes)

deepcopy(g::AdjacencyList) = AdjacencyList(is_directed(g),
                                             deepcopy(g.nodes),
                                             deepcopy(g.timestamps),
                                             g.nnodes,
                                             g.nedges,
                                             deepcopy(g.forward_adjlist))


function forward_neighbors(g::AdjacencyList, v::Int, t::Int)
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
forward_neighbors(g::AdjacencyList, v::Tuple) = forward_neighbors(g, v[1], v[2])

"""
  add_edge!(g, v1, v2, t)

Add a static edge from `v1` to `v2` at time stamp `t` to `g`.
"""
function add_edge!(g::AdjacencyList, v1::Int, v2::Int, t::Int)
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
function _has_edge(g::AdjacencyList, n1::Int, n2::Int)
    nn = length(g.nodes)
    if n1 > nn || n2 > nn
        return false
    end
    return n2 in g.forward_adjlist[n1]
end


"""
  has_edge(g, v1, v2, t)

Returns true if `v1` to `v2` at timestamp `t` is an edge of `g`.
"""
function has_edge(g::AdjacencyList, v1::Int, v2::Int, t::Int)
    ns = g.nnodes
    n1 = v1 + ns*(t-1)
    n2 = v2 + ns*(t-1)
    return _has_edge(g, n1, n2)
end
