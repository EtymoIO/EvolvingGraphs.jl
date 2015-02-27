# EvolvingGraphs

A Julia Package for evolving graphs.

### Types

* Static Graph Types:

	``Node``, ``Edge``, ``AdjacencyList``

* Evolving Graph Types:

	``TimeNode``, ``TimeEdge``

### Algorithms

* Static graph

	- Breath first search: ``BFS(g::AdjacencyList, v::Node)``

	- Depth first search:``DFS(g::AdjacencyList, start_node::Node, end_node::Node)``

### Examples

```julia

	julia> using EvolvingGraphs

	julia> g = build_tree()
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

```
