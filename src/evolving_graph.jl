type EvolvingGraph <: AbstractEvolvingGraph
    vertices::Set{TimeVertex}
    edges::Set{TimeEdge}
end
