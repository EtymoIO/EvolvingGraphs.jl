# find the list index of an evolving graph g
function _find_edge_index(g::AbstractEvolvingGraph, te::TimeEdge)
    tindx = findin(g.timestamps, [time(te)])
    iindx = findin(g.ilist[tindx], [source(te)])
    return findfirst(g.jlist[iindx], target(te))
end


