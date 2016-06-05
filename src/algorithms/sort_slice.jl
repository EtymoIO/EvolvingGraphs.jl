
@doc doc"""
`issorted(g)` returns `true` if the timestamps of the evolving 
graph `g` is sorted and `false` otherwise.
"""->
function issorted(g::AbstractEvolvingGraph)
    return issorted(g.timestamps)
end

@doc doc"""
`sorttime(g)!` sort the evolving graph `g` according to the 
order of timestamps.
"""->
function sorttime!(g::EvolvingGraph)
    p = sortperm(g.timestamps)
    g.edges = g.edges[p]
    g.timestamps = g.timestamps[p]
    g
end

@doc doc"""
`sorttime(g)` sort the evolving graph `g` according to the 
order of timestamps, leaving `g` unmodified.
"""->
sorttime(g::AbstractEvolvingGraph) = sorttime!(deepcopy(g))

@doc doc"""
`slice!(g, t_min, t_max)` slice the evolving graph `g` between the timestamp
`t_min` and `t_max`.
"""->
function slice!(g::EvolvingGraph, t_min, t_max)
    issorted(g) || sorttime!(g)
    a = findfirst(g.timestamps, t_min)
    b = findlast(g.timestamps, t_max) 
    g.edges = g.edges[a:b]
    g.timestamps =  g.timestamps[a:b]
    g
end

@doc doc"""
`slice(g, [n1, n2, ...])` slices the evolving graph `g` according to 
the given nodes, leaving `g` unmodified.
"""->
slice{V}(g::AbstractEvolvingGraph{V}, nodes::Array{V}) = slice!(deepcopy(g), nodes)
    
