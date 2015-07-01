# find the list index of an evolving graph g
# naive implementation

function _find_edge_index(g::AbstractEvolvingGraph, te::EdgeType)
    tindx = findin(g.timestamps, [time(te)])
    iindx = findin(g.ilist, [source(te)])
    jindx = findin(g.jlist, [target(te)])

    return intersect(tindx, iindx, jindx)[1]
end


