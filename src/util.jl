
copy(g::EvolvingGraph) = EvolvingGraph(is_directed(g), g.ilist, g.jlist, g.timestamps)


@doc """
`issorted(g)` returns `true` if the timestamps of the evolving 
graph `g` is sorted and `false` otherwise.
"""->
function issorted(g::AbstractEvolvingGraph)
    return issorted(g.timestamps)
end

@doc """
`sorttime(g)!` sort the evolving graph `g` according to the 
order of timestamps.
"""->
function sorttime!(g::EvolvingGraph)
    p = sortperm(g.timestamps)
    n = length(g.ilist)    
    g.ilist = g.ilist[p]
    g.jlist = g.jlist[p]
    g.timestamps = g.timestamps[p]
    g
end

@doc """
`sorttime(g)` sort the evolving graph `g` according to the 
order of timestamps.
"""->
sorttime(g::EvolvingGraph) = sorttime!(copy(g))

@doc """
`slice!(g, t_min, t_max)` slice the evolving graph `g` between timestamp
`t_min` and `t_max` (not include `t_max`).
"""->
function slice!(g::EvolvingGraph, t_min, t_max)
    issorted(g) || sorttime!(g)
    a = findfirst(g.timestamps, t_min)
    b = findfirst(g.timestamps, t_max) - 1
    g.ilist =  g.ilist[a:b]
    g.jlist =  g.jlist[a:b]
    g.timestamps =  g.timestamps[a:b]
    g
end

@doc """
`slice(g, t_min, t_max)` slice the evolving graph `g` between timestamp
`t_min` and `t_max` (not include `t_max`).
"""->
slice(g::EvolvingGraph, t_min, t_max) = slice!(copy(g), t_min, t_max)


