@doc """
`issorted(g)`
"""->
function issorted(g::AbstractEvolvingGraph)
    return issorted(g.timestamps)
end

@doc """
`sorttime(g)`
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
`slice!(g, t_min, t_max)`
"""->
function slice!(g::EvolvingGraph, t_min, t_max)
    issorted(g) || sorttime!(g)
    a = findfirst(g.timestamps, t_min)
    b = findfirst(g.timestamps, t_max) - 1
    g.ilist =  g.ilist[a : b]
    g.jlist =  g.jlist[a : b]
    g.timestamps =  g.timestamps[a : b]
    g
end
