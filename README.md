# EvolvingGraphs

A Julia Package for evolving graphs.

* [Documentation](http://evolvinggraphsjl.readthedocs.org/en/latest/)

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
	Directed IntEvolvingGraph (6 nodes, 7 edges, 3 timestamps)


	# convert g to adjacency tensor
	julia> adjacency_tensor(g)
	6x6x3 Array{Bool,3}:
	[:, :, 1] =
	false   true  false  false  false  false
	false  false  false  false  false  false
	false  false  false  false  false  false
	false  false  false  false  false  false
	false  false  false  false  false  false
	false  false  false  false  false  false

	[:, :, 2] =
	false  false  false  false  false   true
	false  false   true  false  false  false
	false   true  false  false   true  false
	false  false  false  false  false  false
	false  false  false  false  false  false
	false  false  false  false  false  false

	[:, :, 3] =
	false  false  false  false  false  false
	false  false  false  false   true  false
	false  false  false  false  false  false
	false  false   true  false  false  false
	false  false  false  false  false  false
	true   false  false  false  false  false
	
```
