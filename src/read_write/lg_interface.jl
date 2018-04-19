LightGraphs.nv(g::AbstractGraph{V,E}) where {V,E} = num_nodes(g)
LightGraphs.ne(g::AbstractGraph{V,E}) where {V,E} = num_edges(g)

function LightGraphs.outneighbors(g::AbstractStaticGraph{NT,E}, v::V) where {V, NT<:AbstractNode{V},E}
    edges = out_edges(g, v)
    return Node{V}[target(e) for e in edges]
end

function LightGraphs.inneighbors(g::AbstractStaticGraph{NT,E}, v::V) where {V, NT<:AbstractNode{V},E}
    edges = in_edges(g, v)
    return Node{V}[source(e) for e in edges]
end

LightGraphs.src(e::AbstractEdge{V}) where V = source(e)
LightGraphs.dst(e::AbstractEdge{V}) where V = target(e)

LightGraphs.has_edge(g::AbstractGraph{V,E}, e::AbstractEdge{V}) where {V,E} = has_edge(g,e)
LightGraphs.has_vertex(g::AbstractGraph{V,E}, n::AbstractNode{V}) where {V,E} = has_node(g,n)

Base.reverse(e::AbstractEdge{V}) where V = edge_reverse(e)

LightGraphs.edges(g::AbstractGraph{V,E}) where {V,E} = edges(g)
LightGraphs.edgetype(::AbstractGraph{V,E}) where {V,E} = E

LightGraphs.vertices(g::AbstractGraph{V,E}) where {V,E} = nodes(g)

LightGraphs.is_directed(g::AbstractGraph{V,E}) where {V,E} = is_directed(g)

LightGraphs.add_edge!(g::AbstractStaticGraph{V}, e::AbstractEdge{ET}) where {V,ET} = add_edge!(g, LightGraphs.src(e), LightGraphs.dst(e))
LightGraphs.add_edge!(g::AbstractEvolvingGraph{V,E,T}, e::TimeEdge{ET}) where {V, E, T, ET} = add_edge!(g, LightGraphs.src(e), LightGraphs.dst(e), e.timestamp)
LightGraphs.add_edge!(g::AbstractEvolvingGraph{V,E,T}, e::WeightedTimeEdge{EV,ET,EW}) where {V,E,T,EV,ET,EW} = 
    add_edge!(g, source(v1), target(v2), e.timestamp, weight = e.weight)

function LightGraphs.add_vertex!(g::AbstractStaticGraph{V,E}) where {V<:AbstractNode{T},E} where T<:Integer
    nnodes = num_nodes(g)
    add_node!(g,nnodes+1)
end

# conversions
LightGraphs.SimpleDiGraph(g::AbstractStaticGraph{V,E}) where {V,E} = LightGraphs.SimpleDiGraph(sparse_adjacency_matrix(g))

# TODO not implemented
# interface to implement
    # LightGraphs.AbstractEdge
    # LightGraphs.AbstractEdgeIter
    # LightGraphs.AbstractGraph
    # LightGraphs.rem_edge!
    # LightGraphs.rem_vertex!
