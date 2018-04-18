LightGraphs.nv(g::AbstractGraph) = num_nodes(g)
LightGraphs.ne(g::AbstractGraph) = num_edges(g)
LightGraphs.is_directed(g::AbstractGraph) = is_directed(g)

function LightGraphs.outneighbors(g::AbstractStaticGraph{V}, v::V) where V
    edges = out_edges(g, v)
    return Node{V}[target(e) for e in edges]
end

function LightGraphs.inneighbors(g::AbstractStaticGraph{V}, v::V) where V
    edges = in_edges(g, v)
    return Node{V}[source(e) for e in edges]
end

LightGraphs.src(e::AbstractEdge{V}) where V = source(e) 
LightGraphs.dst(e::AbstractEdge{V}) where V = target(e) 

LightGraphs.has_edge(g::AbstractGraph{V}, e::AbstractEdge{V}) where V = has_edge(g,e)
LightGraphs.has_vertex(g::AbstractGraph{V}, n::AbstractNode{V}) where V = has_node(g,n)

function Base.reverse(e::AbstractEdge{V}) where V = edge_reverse(e)

LightGraphs.edges(g::AbstractGraph{V}) where V = edges(g)
LightGraphs.edgetype(::AbstractGraph{V}) where V = AbstractEdge{V}

LightGraphs.vertices(g::AbstractGraph{V}) where V = nodes(g)

LightGraphs.add_edge!(g::AbstractStaticGraph{V}, e::AbstractEdge{V}) where V = add_edge!(g, source(e), dst(e))
LightGraphs.add_edge!(g::AbstractEvolvingGraph{V}, e::TimeEdge{V,T}) where {V, T} = add_edge!(g, source(e), dst(e), e.timestamp)
LightGraphs.add_edge!(g::AbstractEvolvingGraph{V}, e::TimeWeightedEdge{V,T,W}) where {V,T,W} = 
    add_edge!(g, source(v1), target(v2), e.timestamp, weight = e.weight)

function LightGraphs.add_vertex!(g::AbstractStaticGraph{V}) where V
    nnodes = num_nodes(g)
    add_node!(g,nnodes+1)
end

# interface to implement
    # LightGraphs.AbstractEdge
    # LightGraphs.AbstractEdgeIter
    # LightGraphs.AbstractGraph
    # LightGraphs.rem_edge!
    # LightGraphs.rem_vertex!
