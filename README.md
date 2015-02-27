# EvolvingGraphs

A Julia Package for evolving graphs.

### Types

* Static Graph Types:

	``Node``, ``Edge``, ``IndexNode``, ``AdjacencyList``

* Evolving Graph Types:

	``TimeNode``, ``TimeEdge``, ``TimeEdgeList``

### Algorithms

* Static graph

	- Breath first search: ``BFS(g::AdjacencyList, v::Node)``

	- Depth first search:``DFS(g::AdjacencyList, start_node::Node, end_node::Node)``

### Examples

```julia

	julia> using EvolvingGraphs

	julia> g = build_tree() # build a simple test tree
	Edge Node(a)->Node(b) 
	Edge Node(a)->Node(c) 
	Edge Node(c)->Node(g) 
	Edge Node(b)->Node(d) 
	Edge Node(b)->Node(e) 
	Edge Node(b)->Node(f) 
	Edge Node(g)->Node(h) 

    # find the shortest path from Node('a') to Node('b') on graph g 
	julia> DFS(g, Node('a'), Node('e'))
	path: Node(a)
	path: Node(a) -> Node(b)
	path: Node(a) -> Node(b) -> Node(d)
	path: Node(a) -> Node(b) -> Node(e)
	path: Node(a) -> Node(b) -> Node(f)
	path: Node(a) -> Node(c)
	path: Node(a) -> Node(c) -> Node(g)
	3-element Array{Node{T},1}:
	Node(a)
	Node(b)
	Node(e)

    # label the level of each node on graph g
	julia> BFS(g, Node('a'))
	Dict{Any,Any} with 8 entries:
	Node(f) => 2
	Node(e) => 2
	Node(a) => 0
	Node(c) => 1
	Node(h) => 3
	Node(d) => 2
	Node(b) => 1
	Node(g) => 2

    # build a simple evolving graph
	julia> g = build_evolving_graph()
	IndexNode(a) 
	IndexNode(b) 
	IndexNode(c) 
	IndexNode(d) 
	TimeEdge(IndexNode(a)->IndexNode(b)) at time 1 
	TimeEdge(IndexNode(b)->IndexNode(c)) at time 1 
	TimeEdge(IndexNode(a)->IndexNode(c)) at time 1 
	TimeEdge(IndexNode(a)->IndexNode(d)) at time 1 
	TimeEdge(IndexNode(b)->IndexNode(a)) at time 1 
	TimeEdge(IndexNode(c)->IndexNode(a)) at time 1 
	TimeEdge(IndexNode(a)->IndexNode(b)) at time 2 
	TimeEdge(IndexNode(b)->IndexNode(c)) at time 2 
	TimeEdge(IndexNode(a)->IndexNode(c)) at time 2 
	TimeEdge(IndexNode(a)->IndexNode(c)) at time 3 
	TimeEdge(IndexNode(b)->IndexNode(c)) at time 3 
	TimeEdge(IndexNode(c)->IndexNode(a)) at time 3 

	# convert g to adjacency tensor
	julia> adjacency_tensor(g)
	4x4x3 Array{Float64,3}:
	[:, :, 1] =
	0.0  1.0  1.0  1.0
	1.0  0.0  1.0  0.0
	1.0  0.0  0.0  0.0
	0.0  0.0  0.0  0.0

	[:, :, 2] =
	0.0  1.0  1.0  0.0
	0.0  0.0  1.0  0.0
	0.0  0.0  0.0  0.0
	0.0  0.0  0.0  0.0

	[:, :, 3] =
	0.0  0.0  1.0  0.0
	0.0  0.0  1.0  0.0
	1.0  0.0  0.0  0.0
	0.0  0.0  0.0  0.0

```
