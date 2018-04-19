import LightGraphs

g = DiGraph{Node{String}, Edge{Node{String}}}()

add_node!(g, "a")
add_node!(g, "b")
add_edge!(g, "a", "b")


@test LightGraphs.nv(g) == 2
@test LightGraphs.ne(g) == 1
e = Edge("b", "a")
@test LightGraphs.src(e) == source(e)
@test LightGraphs.dst(e) == target(e)

LightGraphs.add_edge!(g, e)
@test LightGraphs.ne(g) == 2

@test LightGraphs.outneighbors(g, "b") == [Node(1, "a")]
@test LightGraphs.inneighbors(g, "b") == [Node(1, "a")]

@test reverse(e) == Edge("a", "b")
@test LightGraphs.vertices(g) == [Node(1,"a"), Node(2,"b")]
@test LightGraphs.edgetype(g) == Edge{Node{String}}

## issue with package: not defined for StaticGraphs
@test_broken LightGraphs.is_directed(g) == is_directed(g) == true

gint = DiGraph{Node{Int},Edge{Node{Int}}}()
const nnodes = 100
foreach(i->add_node!(gint, i), 1:nnodes)
@test LightGraphs.nv(LightGraphs.SimpleDiGraph(gint)) == nnodes

@test LightGraphs.edgetype(gint) <: EvolvingGraphs.AbstractEdge{NT} where {NT<:EvolvingGraphs.AbstractNode{I}} where {I<:Integer}

LightGraphs.add_vertex!(gint)
@test LightGraphs.nv(gint) == nnodes + 1
