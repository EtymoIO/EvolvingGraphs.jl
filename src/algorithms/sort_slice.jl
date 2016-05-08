
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

function sorttime!(g::AttributeEvolvingGraph)
    p = sortperm(g.timestamps)
    g.ilist = g.ilist[p]
    g.jlist = g.jlist[p]
    g.timestamps = g.timestamps[p]
    g.attributesvec = g.attributesvec[p]
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
    g.ilist =  g.ilist[a:b]
    g.jlist =  g.jlist[a:b]
    g.timestamps =  g.timestamps[a:b]
    g
end

function slice!(g::AttributeEvolvingGraph, t_min, t_max)
    issorted(g) || sorttime!(g)
    a = findfirst(g.timestamps, t_min)
    b = findlast(g.timestamps, t_max)
    g.ilist = g.ilist[a:b]
    g.jlist = g.jlist[a:b]
    g.timestamps = g.timestamps[a:b]
    g.attributesvec = g.attributesvec[a:b]
    g
end

@doc doc"""
`slice(g, t_min, t_max)` slices the evolving graph `g` between timestamp
`t_min` and `t_max`, leaving `g` unmodified.
"""->
slice(g::AbstractEvolvingGraph, t_min, t_max) = slice!(deepcopy(g), t_min, t_max)

@doc doc"""
`slice!(g, [n1, n2,..]) slices the evolving graph `g` according to 
the given nodes.
"""->
function slice!{V}(g::AbstractEvolvingGraph{V}, nodes::Array{V})
    iindx = findin(g.ilist, nodes)
    jindx = findin(g.jlist, nodes)
    nindx = intersect(iindx, jindx)
  
    g.ilist = g.ilist[nindx]
    g.jlist = g.jlist[nindx]
    g.timestamps = g.timestamps[nindx]
    if _has_attribute(g)
        g.attributesvec = g.attributesvec[nindx]
    end
    g
end

@doc doc"""
`slice(g, [n1, n2, ...])` slices the evolving graph `g` according to 
the given nodes, leaving `g` unmodified.
"""->
slice{V}(g::AbstractEvolvingGraph{V}, nodes::Array{V}) = slice!(deepcopy(g), nodes)
    
