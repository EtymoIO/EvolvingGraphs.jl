LightGraphs.nv(g::AbstractStaticGraph{V,E}) where {V,E} = num_nodes(g)
LightGraphs.ne(g::AbstractStaticGraph{V,E}) where {V,E} = num_edges(g)

function LightGraphs.outneighbors(g::AbstractStaticGraph{NT,E}, v::V) where {V, NT<:AbstractNode{V},E}
    edges = out_edges(g, v)
    return Node{V}[target(e) for e in edges]
end
LightGraphs.outneighbors(g::AbstractStaticGraph{V,E}, v::V) where {V,E} = LightGraphs.outneighbors(g,node_key(v))

function LightGraphs.inneighbors(g::AbstractStaticGraph{NT,E}, v::V) where {V, NT<:AbstractNode{V},E}
    edges = in_edges(g, v)
    return Node{V}[source(e) for e in edges]
end
LightGraphs.inneighbors(g::AbstractStaticGraph{V,E}, v::V) where {V,E} = LightGraphs.inneighbors(g,node_key(v))

LightGraphs.src(e::AbstractEdge{V}) where V = source(e)
LightGraphs.dst(e::AbstractEdge{V}) where V = target(e)

LightGraphs.has_edge(g::AbstractStaticGraph{V,E}, e::AbstractEdge{V}) where {V,E} = has_edge(g,e)
LightGraphs.has_vertex(g::AbstractStaticGraph{V,E}, n::AbstractNode{V}) where {V,E} = has_node(g,n)

Base.reverse(e::AbstractEdge{V}) where V = edge_reverse(e)

LightGraphs.edges(g::AbstractStaticGraph{V,E}) where {V,E} = edges(g)
LightGraphs.edgetype(::AbstractStaticGraph{V,E}) where {V,E} = E

LightGraphs.vertices(g::AbstractStaticGraph{V,E}) where {V,E} = nodes(g)

LightGraphs.is_directed(g::AbstractStaticGraph{V,E}) where {V,E} = is_directed(g)

LightGraphs.add_edge!(g::AbstractStaticGraph{V,E}, e::AbstractEdge{V}) where {V,E} = add_edge!(g, LightGraphs.src(e), LightGraphs.dst(e))
LightGraphs.add_edge!(g::AbstractStaticGraph{V,E}, e::AbstractEdge{T}) where {T, V<:AbstractNode{T},E} = add_edge!(g, LightGraphs.src(e), LightGraphs.dst(e))

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
