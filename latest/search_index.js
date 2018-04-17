var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#EvolvingGraphs:-working-with-time-dependent-networks-in-Julia-1",
    "page": "Home",
    "title": "EvolvingGraphs: working with time-dependent networks in Julia",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#Installation-1",
    "page": "Home",
    "title": "Installation",
    "category": "section",
    "text": "Install Julia v0.6.0 or later, if you haven\'t already.julia> Pkg.add(\"EvolvingGraphs\")"
},

{
    "location": "index.html#Get-Started-1",
    "page": "Home",
    "title": "Get Started",
    "category": "section",
    "text": "We model a time-dependent network, a.k.a an evolving graph, as a ordered sequence of static graphs such that each static graph represents the interaction between nodes at a specific time stamp. The figure below shows an evolving graph with 3 timestamps.(Image: simple evolving graph)Using EvolvingGraphs, we could simply construct this graph by using the function add_bunch_of_edges!, which adds a list of edges all together.julia> using EvolvingGraphs\n\njulia> g = EvolvingGraph()\nDirected EvolvingGraph 0 nodes, 0 static edges, 0 timestamps\n\njulia> add_bunch_of_edges!(g, [(1,2,1),(1,3,2),(2,3,3)])\nDirected EvolvingGraph 3 nodes, 3 static edges, 3 timestamps\n\njulia> edges(g)\n3-element Array{EvolvingGraphs.WeightedTimeEdge{EvolvingGraphs.Node{Int64},Int64,Float64},1}:\n Node(1)-1.0->Node(2) at time 1\n Node(1)-1.0->Node(3) at time 2\n Node(2)-1.0->Node(3) at time 3Pages = [\"examples.md\",\"base.md\",\"graph_types.md\",\"centrality.md\", \"read_write.md\", \"algorithms.md\"]\nDepth = 3"
},

{
    "location": "index.html#Index-1",
    "page": "Home",
    "title": "Index",
    "category": "section",
    "text": ""
},

{
    "location": "examples.html#",
    "page": "Tutorial",
    "title": "Tutorial",
    "category": "page",
    "text": ""
},

{
    "location": "examples.html#Tutorial-1",
    "page": "Tutorial",
    "title": "Tutorial",
    "category": "section",
    "text": ""
},

{
    "location": "examples.html#Why-Evolving-Graphs?-1",
    "page": "Tutorial",
    "title": "Why Evolving Graphs?",
    "category": "section",
    "text": "Many real-world networks store the relationship between entities with time stamps. Consider a group of online users interacting through messaging. Each message sent from user v_i to user v_j at time stamp t_i can be represented as an edge from node v_i to node v_j at t_i. It is natural to represent the user interaction network as an ordered sequence of networks, each has a time stamp label. Ignoring the time stamps in the network can give wrong information.Let\'s see a toy example. We let A, B, C be three co-workers working in the same internet company. There was a new assignment for A, B, and C.If A first found out the assignment and told B on day 1 and C on day 2. B reminded C about the assignment on day 3. Now everyone knew about this new assignment. This process is illustrated in the figure below.(Image: simple evolving graph)We can model this example using an evolving graph. In EvolvingGraphs.jl,julia> using EvolvingGraphs\n\njulia> g = EvolvingGraph{Node{String}, Int}()\nDirected EvolvingGraph 0 nodes, 0 static edges, 0 timestamps\n\njulia> add_bunch_of_edges!(g, [(\"A\", \"B\", 1), (\"A\", \"C\", 2), (\"B\", \"C\", 3)])\nDirected EvolvingGraph 3 nodes, 3 static edges, 3 timestamps\n\njulia> edges(g)\n3-element Array{EvolvingGraphs.WeightedTimeEdge{EvolvingGraphs.Node{String},Int64,Float64},1}:\n Node(A)-1.0->Node(B) at time 1\n Node(A)-1.0->Node(C) at time 2\n Node(B)-1.0->Node(C) at time 3It is clear that A is the most important person for passing this information. We use a generalised Katz centrality to evaluate the importance of A, B, and C.julia> using EvolvingGraphs.Centrality\n\njulia> katz(g)\n3-element Array{Tuple{EvolvingGraphs.Node{String},Float64},1}:\n (Node(A), 0.698297)\n (Node(B), 0.567367)\n (Node(C), 0.436436)Suppose our A was a keen person and decided to remind B again in day 2. Now the networks look like(Image: simple evolving graph)In EvolvingGraphs.jl, we add a new edge at timestamp 2.julia> add_edge!(g, \"A\", \"B\", 2)\nNode(A)-1.0->Node(B) at time 2\n\njulia> katz(g)\n3-element Array{Tuple{EvolvingGraphs.Node{String},Float64},1}:\n (Node(A), 0.84485)\n (Node(B), 0.424056)\n (Node(C), 0.326197)Notice that the rating of A is getting even higher than before.If we just aggregate an evolving graph to a simple directed graph by ignoring the timestamps, they aggregate to form the same static graph and therefore the ratings stay the same.(Image: simple graph)Evolving graphs provide richer information and allow us to have a detailed understanding of a real-world problem."
},

{
    "location": "examples.html#Graph-Traversal-1",
    "page": "Tutorial",
    "title": "Graph Traversal",
    "category": "section",
    "text": "How do we traverse an evolving graph? In a breadth-first search (BFS) one first visits all the outward neighbors of the starting node, then visits all the outward neighbors of each of those nodes, and so on.Let\'s look at the implementation of BFS in EvolvingGraphs.jl.function breadth_first_impl(g, v)\n    level = Dict(v => 0)\n    i = 1\n    fronter = [v]\n    while length(fronter) > 0\n        next = []\n        for u in fronter\n            for v in forward_neighbors(g, u)\n                if !(v in keys(level))\n                    level[v] = i\n                    push!(next, v)\n                end\n            end\n        end\n        fronter = next\n        i += 1\n    end\n    level\nendIt looks exactly the same as a BFS in static graphs except here we use forward_neigbors not outward neighbors. forward_neigbors preserves the direction of time and make sure we do not travel back in time."
},

{
    "location": "examples.html#A-List-of-Adjacency-Matrices-1",
    "page": "Tutorial",
    "title": "A List of Adjacency Matrices",
    "category": "section",
    "text": "Researchers often consider an evolving graph as an ordered sequence of adjacency matrices A^{k}. In EvolvingGraphs.jl, we provide a data structure called MatrixList, which stores a list of adjacency matrices.You can convert an evolving graph to an MatrixListjulia> using EvolvingGraphs\n\njulia> g = EvolvingGraph()\nDirected EvolvingGraph 0 nodes, 0 static edges, 0 timestamps\n\njulia> add_bunch_of_edges!(g, [(1,2,2001),(2,3,2002),(3,4,2002),(1,4,2002),(2,3,2003),(2,5,2005)])\nDirected EvolvingGraph 5 nodes, 6 static edges, 4 timestamps\n\njulia> ml = evolving_graph_to_matrices(g)\nMatrixList (4 matrices)and can write a for loop to access its elements.julia> for (i,m) in enumerate(ml)\n        println(\"Matrix $i\")\n        println(m)\n       end\nMatrix 1\n\n  [1, 2]  =  1.0\nMatrix 2\n\n  [2, 3]  =  1.0\n  [1, 4]  =  1.0\n  [3, 4]  =  1.0\nMatrix 3\n\n  [2, 3]  =  1.0\nMatrix 4\n\n  [2, 5]  =  1.0"
},

{
    "location": "base.html#",
    "page": "Base",
    "title": "Base",
    "category": "page",
    "text": ""
},

{
    "location": "base.html#Base-1",
    "page": "Base",
    "title": "Base",
    "category": "section",
    "text": ""
},

{
    "location": "base.html#EvolvingGraphs.AbstractNode",
    "page": "Base",
    "title": "EvolvingGraphs.AbstractNode",
    "category": "type",
    "text": "AbstractNode{V}\n\nAbstract supertype for all node types, where V is the type of the node key.\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.node_index",
    "page": "Base",
    "title": "EvolvingGraphs.node_index",
    "category": "function",
    "text": "node_index(v)\nnode_index(g::AbstractGraph, v)\n\nReturn the index of a node v.\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.node_key",
    "page": "Base",
    "title": "EvolvingGraphs.node_key",
    "category": "function",
    "text": "node_key(v)\n\nReturn the key of a node v.\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.Node",
    "page": "Base",
    "title": "EvolvingGraphs.Node",
    "category": "type",
    "text": "Node(index, key)\nNode{V}(key)\nNode{V}(g, key)\n\nConstructs a Node with node index index of type V and key value key. If only key is given, set index to 0. Node(g, key) constructs a new node in graph g, so index is equal to num_nodes(g) + 1.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> a = Node(1,\"a\")\nNode(a)\n\njulia> node_index(a)\n1\n\njulia> node_key(a)\n\"a\"\n\njulia> b = Node{String}(\"b\")\nNode(b)\n\njulia> node_index(b)\n0\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.AttributeNode",
    "page": "Base",
    "title": "EvolvingGraphs.AttributeNode",
    "category": "type",
    "text": "AttributeNode(index, key, attributes=Dict())\nAttributeNode{K, D_k, D_v}(key, attributes=Dict())\nAttributeNode{K, D_k, D_v}(g, key, attributes=Dict())\n\nConstruct an AttributeNode with index index, key value key and attributes attributes. If index is not given, set index = 0. AttributeNode(g, key, attributes) constructs a new AttributeNode for graph g, where index = num_nodes(g) + 1.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> a = AttributeNode(1, \"a\", Dict(\"a\" => 12))\nAttributeNode(a)\n\njulia> node_key(a)\n\"a\"\n\njulia> node_index(a)\n1\n\njulia> node_attributes(a)\nDict{String,Int64} with 1 entry:\n  \"a\" => 12\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.node_attributes",
    "page": "Base",
    "title": "EvolvingGraphs.node_attributes",
    "category": "function",
    "text": "node_attributes(v)\nnode_attributes(v, g::AbstractGraph)\n\nReturns the attributes of AttributeNode v.\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.TimeNode",
    "page": "Base",
    "title": "EvolvingGraphs.TimeNode",
    "category": "type",
    "text": "TimeNode(index, key, timestamp)\nTimeNode{V,T}(key, timestamp)\nTimeNode{V,T}(g, key, timestamp)\n\nConstructs a TimeNode at timestamp timestamp. TimeNode(g, key, timestamp) constructs a TimeNode in graph g.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> t = TimeNode(1, \"t\", 2018)\nTimeNode(t, 2018)\n\njulia> node_index(t)\n1\n\njulia> node_key(t)\n\"t\"\n\njulia> node_timestamp(t)\n2018\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.node_timestamp",
    "page": "Base",
    "title": "EvolvingGraphs.node_timestamp",
    "category": "function",
    "text": "node_timestamp(v)\n\nReturn the timestamp of TimeNode v.\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.AbstractEdge",
    "page": "Base",
    "title": "EvolvingGraphs.AbstractEdge",
    "category": "type",
    "text": "AbstractEdge{V}\n\nAbstract supertype for all edge types, where V represents the type of the source and target nodes.\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.source",
    "page": "Base",
    "title": "EvolvingGraphs.source",
    "category": "function",
    "text": "source(e)\n\nReturn the source of edge e.\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.target",
    "page": "Base",
    "title": "EvolvingGraphs.target",
    "category": "function",
    "text": "target(e)\n\nReturn the target of edge e.\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.edge_timestamp",
    "page": "Base",
    "title": "EvolvingGraphs.edge_timestamp",
    "category": "function",
    "text": "edge_timestamp(e)\n\nReturn the timestamp of edge e if e is a time dependent edge, i.e., TimeEdge or WeightedTimeEdge.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> e1 = TimeEdge(\"A\", \"B\", 1)\nA->B at time 1\n\njulia> edge_timestamp(e1)\n1\n\njulia> a = Edge(1, 2)\n1->2\n\njulia> edge_timestamp(a)\nERROR: type Edge has no field timestamp\n[...]\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.Edge",
    "page": "Base",
    "title": "EvolvingGraphs.Edge",
    "category": "type",
    "text": "Edge(source, target)\n\nConstruct an Edge from a source node and a target node.\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.edge_reverse",
    "page": "Base",
    "title": "EvolvingGraphs.edge_reverse",
    "category": "function",
    "text": "edge_reverse(e)\n\nReturn the reverse of edge e, i.e., source is now target and target is now source.\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.TimeEdge",
    "page": "Base",
    "title": "EvolvingGraphs.TimeEdge",
    "category": "type",
    "text": "TimeEdge(source, target, timestamp)\n\nConstruct a TimeEdge with source node source, target node target at time stamp timestamp.\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.WeightedTimeEdge",
    "page": "Base",
    "title": "EvolvingGraphs.WeightedTimeEdge",
    "category": "type",
    "text": "WeightedTimeEdge(source, target, weight, timestamp)\nWeightedTimeEdge(source, target, timestamp)\n\nConstruct a WeightedTimeEdge. if weight is not given, set weight = 1.0.\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.edge_weight",
    "page": "Base",
    "title": "EvolvingGraphs.edge_weight",
    "category": "function",
    "text": "edge_weight(e)\n\nReturns the edge weight of a WeightedTimeEdge e.\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.has_node",
    "page": "Base",
    "title": "EvolvingGraphs.has_node",
    "category": "function",
    "text": "has_node(e, v)\nhas_node(g, v)\n\nIn the first case, return true if v is a node of the edge e. In the second case, return true if graph g contains node v and false otherwise, where v can a node type object or a node key.\n\n\n\n"
},

{
    "location": "base.html#Nodes-and-Edges-1",
    "page": "Base",
    "title": "Nodes and Edges",
    "category": "section",
    "text": "Node and edge types and functions.EvolvingGraphs.AbstractNode\nEvolvingGraphs.node_index\nEvolvingGraphs.node_key\nEvolvingGraphs.Node\nEvolvingGraphs.AttributeNode\nEvolvingGraphs.node_attributes\nEvolvingGraphs.TimeNode\nEvolvingGraphs.node_timestamp\nEvolvingGraphs.AbstractEdge\nEvolvingGraphs.source\nEvolvingGraphs.target\nEvolvingGraphs.edge_timestamp\nEvolvingGraphs.Edge\nEvolvingGraphs.edge_reverse\nEvolvingGraphs.TimeEdge\nEvolvingGraphs.WeightedTimeEdge\nEvolvingGraphs.edge_weight\nEvolvingGraphs.has_node"
},

{
    "location": "base.html#EvolvingGraphs.AbstractPath",
    "page": "Base",
    "title": "EvolvingGraphs.AbstractPath",
    "category": "type",
    "text": "AbstractPath\n\nAbstract supertype for all path types.\n\n\n\n"
},

{
    "location": "base.html#EvolvingGraphs.TemporalPath",
    "page": "Base",
    "title": "EvolvingGraphs.TemporalPath",
    "category": "type",
    "text": "TemporalPath()\n\nConstruct a TemporalPath, i.e., an array of TimeNode.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> p = TemporalPath()\n\n\njulia> push!(p, TimeNode(1, \"a\", 2001))\nTimeNode(a, 2001)\n\njulia> push!(p, TimeNode(1, \"b\", 2002))\nTimeNode(a, 2001)->TimeNode(b, 2002)\n\njulia> p\nTimeNode(a, 2001)->TimeNode(b, 2002)\n\njulia> append!(p,p)\nTimeNode(a, 2001)->TimeNode(b, 2002)->TimeNode(a, 2001)->TimeNode(b, 2002)\n\n\n\n"
},

{
    "location": "base.html#Paths-1",
    "page": "Base",
    "title": "Paths",
    "category": "section",
    "text": "Path types and functions.EvolvingGraphs.AbstractPath\nEvolvingGraphs.TemporalPath"
},

{
    "location": "graph_types.html#",
    "page": "Graph Types",
    "title": "Graph Types",
    "category": "page",
    "text": ""
},

{
    "location": "graph_types.html#EvolvingGraphs.AbstractGraph",
    "page": "Graph Types",
    "title": "EvolvingGraphs.AbstractGraph",
    "category": "type",
    "text": "AbstractGraph{V,E}\n\nAbstract supertype for all graph types, where V represents node type and E represents edge type.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.AbstractEvolvingGraph",
    "page": "Graph Types",
    "title": "EvolvingGraphs.AbstractEvolvingGraph",
    "category": "type",
    "text": "AbstractEvolvingGraph{V,E,T} <: AbstractGraph{V,E}\n\nAbstract supertype for all evolving graph types, where V represents node type, E represents edge type, and T represents timestamp type.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.AbstractStaticGraph",
    "page": "Graph Types",
    "title": "EvolvingGraphs.AbstractStaticGraph",
    "category": "type",
    "text": "AbstractStaticGraph{V,E} <: AbstractGraph{V,E}\n\nAbstract supertype for all static graph types, where V represents node type and E represents edge etype.\n\n\n\n"
},

{
    "location": "graph_types.html#Graph-Types-1",
    "page": "Graph Types",
    "title": "Graph Types",
    "category": "section",
    "text": "EvolvingGraphs.AbstractGraph\nEvolvingGraphs.AbstractEvolvingGraph\nEvolvingGraphs.AbstractStaticGraph"
},

{
    "location": "graph_types.html#EvolvingGraphs.EvolvingGraph",
    "page": "Graph Types",
    "title": "EvolvingGraphs.EvolvingGraph",
    "category": "type",
    "text": "EvolvingGraph{V,T}(;is_directed=true; is_weighted=true)\nEvolvingGraph(;is_directed=true; is_weighted=true)\n\nConstruct an evolving graph with node type V and timestamp type T. EvolvingGraph() constructs a simple evolving graph with integer nodes and timestamps.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> g = EvolvingGraph{Node{String},Int}(is_weighted=false)\nDirected EvolvingGraph 0 nodes, 0 static edges, 0 timestamps\n\njulia> add_node!(g, \"a\")\nNode(a)\n\njulia> add_node!(g, \"b\")\nNode(b)\n\njulia> num_nodes(g)\n2\n\njulia> add_edge!(g, \"a\", \"b\", 2001)\nNode(a)->Node(b) at time 2001\n\njulia> add_edge!(g, \"a\", \"c\", 2002)\nNode(a)->Node(c) at time 2002\n\njulia> timestamps(g)\n2-element Array{Int64,1}:\n 2001\n 2002\n\njulia> active_nodes(g)\n4-element Array{EvolvingGraphs.TimeNode{String,Int64},1}:\n TimeNode(a, 2001)\n TimeNode(b, 2001)\n TimeNode(a, 2002)\n TimeNode(c, 2002)\n\njulia> g = EvolvingGraph()\nDirected EvolvingGraph 0 nodes, 0 static edges, 0 timestamps\n\njulia> add_edge!(g, 1, 2, 1)\nNode(1)-1.0->Node(2) at time 1\n\njulia> add_edge!(g, 2, 3, 2)\nNode(2)-1.0->Node(3) at time 2\n\njulia> add_edge!(g, 1, 3, 2)\nNode(1)-1.0->Node(3) at time 2\n\njulia> nodes(g)\n3-element Array{EvolvingGraphs.Node{Int64},1}:\n Node(1)\n Node(2)\n Node(3)\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.evolving_graph_from_arrays",
    "page": "Graph Types",
    "title": "EvolvingGraphs.evolving_graph_from_arrays",
    "category": "function",
    "text": "evolving_graph_from_arrays(ils, jls, wls, timestamps; is_directed=true)\nevolving_graph_from_arrays(ils, jls, timestamps; is_directed=true)\n\nGenerate an EvolvingGraph type object from four input arrays: ils, jls, wls and timestamps, such that the ith entry (ils[i], jls[i], wls[i], timestamps[i]) represents a WeightedTimeEdge from ils[i] to jls[i] with edge weight wls[i] at timestamp timestamp[i]. By default, wls is a vector of ones.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> g = evolving_graph_from_arrays([1,2,3], [4,5,2], [1,1,2])\nDirected EvolvingGraph 5 nodes, 3 static edges, 2 timestamps\n\njulia> nodes(g)\n5-element Array{EvolvingGraphs.Node{Int64},1}:\n Node(1)\n Node(4)\n Node(2)\n Node(5)\n Node(3)\n\njulia> edges(g)\n3-element Array{EvolvingGraphs.WeightedTimeEdge{EvolvingGraphs.Node{Int64},Int64,Float64},1}:\n Node(1)-1.0->Node(4) at time 1\n Node(2)-1.0->Node(5) at time 1\n Node(3)-1.0->Node(2) at time 2\n\njulia> g = evolving_graph_from_arrays([1,2], [2, 3], [2.5, 3.8], [1998,2001])\nDirected EvolvingGraph 3 nodes, 2 static edges, 2 timestamps\n\njulia> edges(g)\n2-element Array{EvolvingGraphs.WeightedTimeEdge{EvolvingGraphs.Node{Int64},Int64,Float64},1}:\n Node(1)-2.5->Node(2) at time 1998\n Node(2)-3.8->Node(3) at time 2001\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.adjacency_matrix",
    "page": "Graph Types",
    "title": "EvolvingGraphs.adjacency_matrix",
    "category": "function",
    "text": "adjacency_matrix(g, t)\n\nReturn an adjacency matrix representation of an evolving graph g at timestamp t.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> g = evolving_graph_from_arrays([1,2,3], [4,5,2], [1,1,2])\nDirected EvolvingGraph 5 nodes, 3 static edges, 2 timestamps\n\njulia> adjacency_matrix(g, 1)\n5×5 Array{Float64,2}:\n 0.0  1.0  0.0  0.0  0.0\n 0.0  0.0  0.0  0.0  0.0\n 0.0  0.0  0.0  1.0  0.0\n 0.0  0.0  0.0  0.0  0.0\n 0.0  0.0  0.0  0.0  0.0\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.sparse_adjacency_matrix",
    "page": "Graph Types",
    "title": "EvolvingGraphs.sparse_adjacency_matrix",
    "category": "function",
    "text": "sparse_adjacency_matrix(g, t)\n\nReturn a sparse adjacency matrix representation of an evolving graph g at timestamp t.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> g = evolving_graph_from_arrays([1,2,3], [4,5,2], [1,1,2])\nDirected EvolvingGraph 5 nodes, 3 static edges, 2 timestamps\n\njulia> sparse_adjacency_matrix(g,2)\n5×5 SparseMatrixCSC{Float64,Int64} with 1 stored entry:\n  [5, 3]  =  1.0\n\njulia> sparse_adjacency_matrix(g,1)\n5×5 SparseMatrixCSC{Float64,Int64} with 2 stored entries:\n  [1, 2]  =  1.0\n  [3, 4]  =  1.0\n\n\n\n"
},

{
    "location": "graph_types.html#Evolving-Graphs-1",
    "page": "Graph Types",
    "title": "Evolving Graphs",
    "category": "section",
    "text": "EvolvingGraphs.EvolvingGraph\nEvolvingGraphs.evolving_graph_from_arrays\nEvolvingGraphs.adjacency_matrix\nEvolvingGraphs.sparse_adjacency_matrix"
},

{
    "location": "graph_types.html#EvolvingGraphs.MatrixList",
    "page": "Graph Types",
    "title": "EvolvingGraphs.MatrixList",
    "category": "type",
    "text": "MatrixList\n\nData type of storing a list of sparse matrices in CSC format.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.evolving_graph_to_matrices",
    "page": "Graph Types",
    "title": "EvolvingGraphs.evolving_graph_to_matrices",
    "category": "function",
    "text": "evolving_graph_to_matrices(g)\n\nConvert an evolving graph g to a matrix list.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> g = EvolvingGraph()\nDirected EvolvingGraph 0 nodes, 0 static edges, 0 timestamps\n\njulia> add_bunch_of_edges!(g, [(1,2,1), (2,4,1), (2,3,1), (3,4,2), (1,3,3)])\nDirected EvolvingGraph 4 nodes, 5 static edges, 3 timestamps\n\njulia> ml = evolving_graph_to_matrices(g)\nMatrixList (3 matrices)\n\njulia> sparse_adjacency_matrix(ml, 1)\n4×4 SparseMatrixCSC{Float64,Int64} with 3 stored entries:\n  [1, 2]  =  1.0\n  [2, 3]  =  1.0\n  [2, 4]  =  1.0\n\njulia> sparse_adjacency_matrix(ml,2)\n4×4 SparseMatrixCSC{Float64,Int64} with 1 stored entry:\n  [4, 3]  =  1.0\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.matrices",
    "page": "Graph Types",
    "title": "EvolvingGraphs.matrices",
    "category": "function",
    "text": "matrices(ml)\n\nReturn a list of matrices in MatrixList ml.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.num_matrices",
    "page": "Graph Types",
    "title": "EvolvingGraphs.num_matrices",
    "category": "function",
    "text": "num_matrices(ml)\n\nReturn the number of matrices in MatrixList ml.\n\n\n\n"
},

{
    "location": "graph_types.html#Matrix-List-1",
    "page": "Graph Types",
    "title": "Matrix List",
    "category": "section",
    "text": "EvolvingGraphs.MatrixList\nEvolvingGraphs.evolving_graph_to_matrices\nEvolvingGraphs.matrices\nEvolvingGraphs.num_matrices"
},

{
    "location": "graph_types.html#EvolvingGraphs.IntAdjacencyList",
    "page": "Graph Types",
    "title": "EvolvingGraphs.IntAdjacencyList",
    "category": "type",
    "text": "IntAdjacencyList(nv, nt)\n\nConstruct a graph represented by an adjacency list with nv nodes and nt timestamps, where both nodes and timestamps are represented by integers.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> g = IntAdjacencyList(4,3)\nDirected IntAdjacencyList (4 nodes, 0 static edges, 3 timestamps)\n\njulia> add_edge!(g, 1, 2, 1)\nDirected IntAdjacencyList (4 nodes, 1 static edges, 3 timestamps)\n\njulia> add_edge!(g, 2, 3, 2)\nDirected IntAdjacencyList (4 nodes, 2 static edges, 3 timestamps)\n\njulia> num_edges(g)\n2\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.evolving_graph_to_adj",
    "page": "Graph Types",
    "title": "EvolvingGraphs.evolving_graph_to_adj",
    "category": "function",
    "text": "evolving_graph_to_adj(g)\n\nConvert an evolving graph g to an adjacency list.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> g = EvolvingGraph()\nDirected EvolvingGraph 0 nodes, 0 static edges, 0 timestamps\n\njulia> add_bunch_of_edges!(g, [(1,2,2001),(2,3,2002), (2,4,2002), (3,1,2003)])\nDirected EvolvingGraph 4 nodes, 4 static edges, 3 timestamps\n\njulia> evolving_graph_to_adj(g)\nDirected IntAdjacencyList (4 nodes, 4 static edges, 3 timestamps)\n\n\n\n"
},

{
    "location": "graph_types.html#Adjacency-List-1",
    "page": "Graph Types",
    "title": "Adjacency List",
    "category": "section",
    "text": "EvolvingGraphs.IntAdjacencyList\nEvolvingGraphs.evolving_graph_to_adj"
},

{
    "location": "graph_types.html#EvolvingGraphs.DiGraph",
    "page": "Graph Types",
    "title": "EvolvingGraphs.DiGraph",
    "category": "type",
    "text": "DiGraph{V,E}()\nDiGraph{V}()\nDiGraph()\n\nConstruct a static directed graph with node type V and edge type E. DiGraph() constructs a static directed graph with integer nodes and edges.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> g = DiGraph()\nDiGraph 0 nodes, 0 edges\n\njulia> add_edge!(g, 1, 2)\nNode(1)->Node(2)\n\njulia> add_edge!(g, 2, 3)\nNode(2)->Node(3)\n\njulia> adjacency_matrix(g)\n3×3 Array{Float64,2}:\n 0.0  1.0  0.0\n 0.0  0.0  1.0\n 0.0  0.0  0.0\n\njulia> add_node!(g, 4)\nNode(4)\n\njulia> nodes(g)\n4-element Array{EvolvingGraphs.Node{Int64},1}:\n Node(1)\n Node(2)\n Node(3)\n Node(4)\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.out_edges",
    "page": "Graph Types",
    "title": "EvolvingGraphs.out_edges",
    "category": "function",
    "text": "out_edges(g, v)\n\nReturn the outward edges of node v in a static graph g, where v can be a node or a node key.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> g = DiGraph()\nDiGraph 0 nodes, 0 edges\n\njulia> add_bunch_of_edges!(g, [(1,2), (2,3), (3,4)])\nDiGraph 4 nodes, 3 edges\n\njulia> out_edges(g, 1)\n1-element Array{EvolvingGraphs.Edge{EvolvingGraphs.Node{Int64}},1}:\n Node(1)->Node(2)\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.out_degree",
    "page": "Graph Types",
    "title": "EvolvingGraphs.out_degree",
    "category": "function",
    "text": "out_degree(g, v)\n\nReturn the number of outward edges of node v in static graph g, where v can be a node of a node key.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.in_edges",
    "page": "Graph Types",
    "title": "EvolvingGraphs.in_edges",
    "category": "function",
    "text": "in_edges(g, v)\n\nReturn the inward edges of node v in static graph g.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> g = DiGraph()\nDiGraph 0 nodes, 0 edges\n\njulia> add_bunch_of_edges!(g, [(2,1), (3,1), (4,1)])\nDiGraph 4 nodes, 3 edges\n\njulia> in_edges(g,1)\n3-element Array{EvolvingGraphs.Edge{EvolvingGraphs.Node{Int64}},1}:\n Node(2)->Node(1)\n Node(3)->Node(1)\n Node(4)->Node(1)\n\njulia> in_degree(g,1)\n3\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.in_degree",
    "page": "Graph Types",
    "title": "EvolvingGraphs.in_degree",
    "category": "function",
    "text": "in_degree(g, v)\n\nReturn the number of inward edges of node v in static graph g.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.aggregate_graph",
    "page": "Graph Types",
    "title": "EvolvingGraphs.aggregate_graph",
    "category": "function",
    "text": "aggregate_graph(g)\n\nConvert an evolving graph g to a static graph by aggregate the edges to the same timestamp.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> eg = EvolvingGraph()\nDirected EvolvingGraph 0 nodes, 0 static edges, 0 timestamps\n\njulia> add_bunch_of_edges!(eg, [(1,2,3), (2,3,4), (1,2,1)])\nDirected EvolvingGraph 3 nodes, 3 static edges, 3 timestamps\n\njulia> aggregate_graph(eg)\nDiGraph 3 nodes, 2 edges\n\n\n\n"
},

{
    "location": "graph_types.html#Static-Graphs-1",
    "page": "Graph Types",
    "title": "Static Graphs",
    "category": "section",
    "text": "EvolvingGraphs.DiGraph\nEvolvingGraphs.out_edges\nEvolvingGraphs.out_degree\nEvolvingGraphs.in_edges\nEvolvingGraphs.in_degree\nEvolvingGraphs.aggregate_graph"
},

{
    "location": "graph_types.html#EvolvingGraphs.nodes",
    "page": "Graph Types",
    "title": "EvolvingGraphs.nodes",
    "category": "function",
    "text": "nodes(g)\n\nReturn the nodes of a graph g.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.num_nodes",
    "page": "Graph Types",
    "title": "EvolvingGraphs.num_nodes",
    "category": "function",
    "text": "num_nodes(g)\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.active_nodes",
    "page": "Graph Types",
    "title": "EvolvingGraphs.active_nodes",
    "category": "function",
    "text": "active_nodes(g)\n\nReturn the active nodes of an evolving graph g.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.num_active_nodes",
    "page": "Graph Types",
    "title": "EvolvingGraphs.num_active_nodes",
    "category": "function",
    "text": "num_active_nodes(g)\n\nReturn the number of active nodes of evolving graph g.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.add_node!",
    "page": "Graph Types",
    "title": "EvolvingGraphs.add_node!",
    "category": "function",
    "text": "add_node!(g, v)\n\nAdd a node to graph g, where v can be either a node type object or a node key.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.find_node",
    "page": "Graph Types",
    "title": "EvolvingGraphs.find_node",
    "category": "function",
    "text": "find_node(g, v)\n\nReturn node v if v is a node of graph g, otherwise return false. If v is a node key, return corresponding node.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.edges",
    "page": "Graph Types",
    "title": "EvolvingGraphs.edges",
    "category": "function",
    "text": "edges(g)\nedges(g, t)\n\nReturn all the edges of graph g. If timestamp t is given, returns all the edges at timestamp t.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.num_edges",
    "page": "Graph Types",
    "title": "EvolvingGraphs.num_edges",
    "category": "function",
    "text": "num_edges(g)\n\nReturn the number of edges of graph g.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.add_edge!",
    "page": "Graph Types",
    "title": "EvolvingGraphs.add_edge!",
    "category": "function",
    "text": "add_edge!(g, v1, v2, t; weight = 1.0)\n\nAdd an edge from v1 to v2 at timestamp t to evolving graph g. By default edge weight weight is equal to 1.0.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.add_bunch_of_edges!",
    "page": "Graph Types",
    "title": "EvolvingGraphs.add_bunch_of_edges!",
    "category": "function",
    "text": "add_bunch_of_edges!(g, ebunch)\n\nAdd a bunch of edges to graph g where ebunch is an array of edges. Each edge in ebunch is of form (source, target, timestamp) or (source, target, timestamp, weight).\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> g = EvolvingGraph()\nDirected EvolvingGraph 0 nodes, 0 static edges, 0 timestamps\n\njulia> add_bunch_of_edges!(g, [(1,2,2001), (2,3,2001), (3,1,2002), (2,3,2004)])\nDirected EvolvingGraph 3 nodes, 4 static edges, 3 timestamps\n\njulia> timestamps(g)\n4-element Array{Int64,1}:\n 2001\n 2001\n 2002\n 2004\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.is_directed",
    "page": "Graph Types",
    "title": "EvolvingGraphs.is_directed",
    "category": "function",
    "text": "is_directed(g)\n\nDetermine if a graph g is a directed graph.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.timestamps",
    "page": "Graph Types",
    "title": "EvolvingGraphs.timestamps",
    "category": "function",
    "text": "timestamps(g)\n\nReturn the timestamps of graph g.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.unique_timestamps",
    "page": "Graph Types",
    "title": "EvolvingGraphs.unique_timestamps",
    "category": "function",
    "text": "unique_timestamps(g)\n\nReturn the unique timestamps of graph g.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.num_timestamps",
    "page": "Graph Types",
    "title": "EvolvingGraphs.num_timestamps",
    "category": "function",
    "text": "num_timestamps(g)\n\nReturn the number of timestamps of graph g.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.forward_neighbors",
    "page": "Graph Types",
    "title": "EvolvingGraphs.forward_neighbors",
    "category": "function",
    "text": "forward_neighbors(g, v)\n\nFind the forward neighbors of a node v in graph g. If g is an evolving graph, we define the forward neighbors of a TimeNode v to be a collection of forward neighbors at time stamp node_timestamp(v) and the same node key at later time stamps.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> g = evolving_graph_from_arrays([1,1,2],[2,3,3], [1,2,3])\nDirected EvolvingGraph 3 nodes, 3 static edges, 3 timestamps\n\njulia> n = active_nodes(g)[1]\nTimeNode(1, 1)\n\njulia> forward_neighbors(g,n)\n2-element Array{EvolvingGraphs.TimeNode{Int64,Int64},1}:\n TimeNode(2, 1)\n TimeNode(1, 2)\n\nReferences:\n\nJiahao Chen and Weijian Zhang, The Right Way to Search Evolving Graphs, Proceedings of IPDPS 2016.\n\n\n\n"
},

{
    "location": "graph_types.html#EvolvingGraphs.backward_neighbors",
    "page": "Graph Types",
    "title": "EvolvingGraphs.backward_neighbors",
    "category": "function",
    "text": "backward_neighbors(g, v)\n\nFind the backward neighbors of a node v in graph g. If g is an evolving graph, we define the backward neighbors of a TimeNode v to be a collection of backward neighbors at time stamp node_timestamp(v) and the same node key at earlier time stamps.\n\njulia> using EvolvingGraphs\n\njulia> g = evolving_graph_from_arrays([1,1,2],[2,3,3], [1,2,3])\nDirected EvolvingGraph 3 nodes, 3 static edges, 3 timestamps\n\njulia> n = active_nodes(g)[2]\nTimeNode(2, 1)\n\njulia> backward_neighbors(g,n)\n1-element Array{EvolvingGraphs.TimeNode{Int64,Int64},1}:\n TimeNode(1, 1)\n\nReferences:\n\nJiahao Chen and Weijian Zhang, The Right Way to Search Evolving Graphs, Proceedings of IPDPS 2016.\n\n\n\n"
},

{
    "location": "graph_types.html#General-Functions-1",
    "page": "Graph Types",
    "title": "General Functions",
    "category": "section",
    "text": "EvolvingGraphs.nodes\nEvolvingGraphs.num_nodes\nEvolvingGraphs.active_nodes\nEvolvingGraphs.num_active_nodes\nEvolvingGraphs.add_node!\nEvolvingGraphs.find_node\nEvolvingGraphs.edges\nEvolvingGraphs.num_edges\nEvolvingGraphs.add_edge!\nEvolvingGraphs.add_bunch_of_edges!\nEvolvingGraphs.is_directed\nEvolvingGraphs.timestamps\nEvolvingGraphs.unique_timestamps\nEvolvingGraphs.num_timestamps\nEvolvingGraphs.forward_neighbors\nEvolvingGraphs.backward_neighbors"
},

{
    "location": "centrality.html#",
    "page": "Graph Centrality",
    "title": "Graph Centrality",
    "category": "page",
    "text": ""
},

{
    "location": "centrality.html#EvolvingGraphs.Centrality.katz",
    "page": "Graph Centrality",
    "title": "EvolvingGraphs.Centrality.katz",
    "category": "function",
    "text": "katz(g, alpha = 0.1)\n\nCompute the Katz centrality for a static graph g.\n\nReferences:\n\nL. Katz A new index derived from sociometric data analysis. Psychometrika, 18:39-43, 1953.\n\n\n\nkatz(g, alpha = 0.3)\nkatz(g, alpha, beta; mode = :broadcast)\n\nComputes the katz centrality for an evolving graph g, where alpha and beta are scalars. alpha controls the influence of long walks and beta controls the influence of walks happened long time ago. By default, mode = :broadcast computes the broadcast centrality. Otherwise if mode = :receive, we compute the receiving centrality.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> using EvolvingGraphs.Centrality\n\njulia> g = evolving_graph_from_arrays([\"A\", \"B\", \"B\", \"C\", \"E\", \"A\", \"B\", \"D\"], [\"B\", \"F\", \"G\", \"E\", \"G\", \"B\", \"F\", \"F\"], [1,1,1,2,2,2,2,2])\nDirected EvolvingGraph 7 nodes, 8 static edges, 2 timestamps\n\njulia> katz(g)\n7-element Array{Tuple{EvolvingGraphs.Node{String},Float64},1}:\n (Node(A), 0.776825)\n (Node(B), 0.3916)\n (Node(F), 0.0910698)\n (Node(G), 0.0910698)\n (Node(C), 0.350619)\n (Node(E), 0.227674)\n (Node(D), 0.227674)\n\njulia> katz(g, 0.3, 0.4, mode = :receive)\n7-element Array{Tuple{EvolvingGraphs.Node{String},Float64},1}:\n (Node(A), 0.0)\n (Node(B), 0.441673)\n (Node(F), 1.0)\n (Node(G), 0.548645)\n (Node(C), 0.0)\n (Node(E), 0.42231)\n (Node(D), 0.0)\n\nReferences:\n\nP. Grindrod, D. J. Higham, M. C. Parsons and E. Estrada Communicability across evolving networks. Physical Review E, 83 2011.\nP. Grindrod and D. J. Higham, A matrix iteration for dynamic network summaries. SIAM Review, 55 2013.\n\n\n\n"
},

{
    "location": "centrality.html#Graph-Centrality-1",
    "page": "Graph Centrality",
    "title": "Graph Centrality",
    "category": "section",
    "text": "katz"
},

{
    "location": "read_write.html#",
    "page": "Read and Write",
    "title": "Read and Write",
    "category": "page",
    "text": ""
},

{
    "location": "read_write.html#Read-and-Write-1",
    "page": "Read and Write",
    "title": "Read and Write",
    "category": "section",
    "text": "[To add soon]"
},

{
    "location": "algorithms.html#",
    "page": "Algorithms",
    "title": "Algorithms",
    "category": "page",
    "text": ""
},

{
    "location": "algorithms.html#Algorithms-1",
    "page": "Algorithms",
    "title": "Algorithms",
    "category": "section",
    "text": ""
},

{
    "location": "algorithms.html#EvolvingGraphs.depth_first_impl",
    "page": "Algorithms",
    "title": "EvolvingGraphs.depth_first_impl",
    "category": "function",
    "text": "depth_first_impl(g, i, j, verbose = true)\ndepth_first_impl(g, i_key, i_t, j_key, j_t, verbose = true)\n\nFind the shortest temporal path between TimeNode i and j on an evolving graph g using DFS. Alternatively, we could inpute the node keys i_key, j_key and node timestamps i_t, j_t respectively.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> g = EvolvingGraph{Node{String}, Int}()\nDirected EvolvingGraph 0 nodes, 0 static edges, 0 timestamps\n\njulia> add_bunch_of_edges!(g, [(\"A\", \"B\", 1), (\"B\", \"F\", 1), (\"B\", \"G\", 1), (\"C\", \"E\", 2), (\"E\", \"G\", 2), (\"A\", \"B\", 2), (\"A\", \"B\", 3), (\"C\", \"F\", 3), (\"E\",\"G\", 3)])\nDirected EvolvingGraph 6 nodes, 9 static edges, 3 timestamps\n\njulia> depth_first_impl(g, \"A\", 1, \"F\", 3)\nCurrent path: TimeNode(A, 1)\nCurrent path: TimeNode(A, 1)->TimeNode(B, 1)\nCurrent path: TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(F, 1)\nCurrent path: TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(F, 1)->TimeNode(F, 3)\nCurrent path: TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(G, 1)\nCurrent path: TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(G, 1)->TimeNode(G, 2)\nCurrent path: TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(G, 1)->TimeNode(G, 3)\nCurrent path: TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(B, 2)\nCurrent path: TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(B, 2)->TimeNode(B, 3)\nCurrent path: TimeNode(A, 1)->TimeNode(B, 1)->TimeNode(B, 3)\nCurrent path: TimeNode(A, 1)->TimeNode(A, 2)\nCurrent path: TimeNode(A, 1)->TimeNode(A, 2)->TimeNode(B, 2)\nCurrent path: TimeNode(A, 1)->TimeNode(A, 2)->TimeNode(B, 2)->TimeNode(B, 3)\nCurrent path: TimeNode(A, 1)->TimeNode(A, 2)->TimeNode(A, 3)\nCurrent path: TimeNode(A, 1)->TimeNode(A, 2)->TimeNode(A, 3)->TimeNode(B, 3)\nCurrent path: TimeNode(A, 1)->TimeNode(A, 3)\nCurrent path: TimeNode(A, 1)->TimeNode(A, 3)->TimeNode(B, 3)\nTimeNode(A, 1)->TimeNode(B, 1)->TimeNode(F, 1)->TimeNode(F, 3)\n\n\n\n"
},

{
    "location": "algorithms.html#EvolvingGraphs.breadth_first_impl",
    "page": "Algorithms",
    "title": "EvolvingGraphs.breadth_first_impl",
    "category": "function",
    "text": "breadth_first_impl(g,i)\n\nFind all the reachable node from TimeNode i using BFS.\n\nExample\n\njulia> using EvolvingGraphs\n\njulia> g = EvolvingGraph{Node{String}, Int}()\nDirected EvolvingGraph 0 nodes, 0 static edges, 0 timestamps\n\njulia> add_bunch_of_edges!(g, [(\"A\", \"B\", 1), (\"B\", \"F\", 1), (\"B\", \"G\", 1), (\"C\", \"E\", 2), (\"E\", \"G\", 2), (\"A\", \"B\", 2), (\"A\", \"B\", 3), (\"C\", \"F\", 3), (\"E\",\"G\", 3)])\nDirected EvolvingGraph 6 nodes, 9 static edges, 3 timestamps\n\njulia> breadth_first_impl(g, \"A\", 1)\nDict{EvolvingGraphs.TimeNode{String,Int64},Int64} with 14 entries:\n  TimeNode(B, 3) => 2\n  TimeNode(B, 3) => 2\n  TimeNode(A, 2) => 1\n  TimeNode(F, 1) => 2\n  TimeNode(G, 3) => 3\n  TimeNode(A, 3) => 1\n  TimeNode(A, 1) => 0\n  TimeNode(F, 3) => 3\n  TimeNode(B, 3) => 3\n  TimeNode(G, 1) => 2\n  TimeNode(B, 2) => 2\n  TimeNode(B, 2) => 2\n  TimeNode(G, 2) => 3\n  TimeNode(B, 1) => 1\n\n\n\n"
},

{
    "location": "algorithms.html#Search-1",
    "page": "Algorithms",
    "title": "Search",
    "category": "section",
    "text": "EvolvingGraphs.depth_first_impl\nEvolvingGraphs.breadth_first_impl"
},

{
    "location": "algorithms.html#EvolvingGraphs.random_graph",
    "page": "Algorithms",
    "title": "EvolvingGraphs.random_graph",
    "category": "function",
    "text": "random_graph(n,p=0.5, has_self_loops=false)\n\ngenerate a random directed graph g with n nodes and the probability to include edge is p. If has_self_loops, g will include self loops.\n\n\n\n"
},

{
    "location": "algorithms.html#EvolvingGraphs.random_evolving_graph",
    "page": "Algorithms",
    "title": "EvolvingGraphs.random_evolving_graph",
    "category": "function",
    "text": "random_evolving_graph(nv, nt, p=0.5, is_directed=true, has_self_loops=false)\n\nGenerate a random evolving graph g with nv nodes, nt timestamps. The probability to include each edge is equal to p. If has_self_loops, we allow g to have self loops.\n\n\n\n"
},

{
    "location": "algorithms.html#Random-Graphs-1",
    "page": "Algorithms",
    "title": "Random Graphs",
    "category": "section",
    "text": "EvolvingGraphs.random_graph\nEvolvingGraphs.random_evolving_graph"
},

{
    "location": "algorithms.html#Base.issorted",
    "page": "Algorithms",
    "title": "Base.issorted",
    "category": "function",
    "text": "issorted(g)\n\nReturn true if the timestamps of an evolving graph g is sorted and false otherwise.\n\n\n\n"
},

{
    "location": "algorithms.html#EvolvingGraphs.sort_timestamps!",
    "page": "Algorithms",
    "title": "EvolvingGraphs.sort_timestamps!",
    "category": "function",
    "text": "sort_timestamps!(g)\n\nSort an evolving graph g according to the order of its timestamps.\n\njulia> using EvolvingGraphs\n\njulia> g = EvolvingGraph()\nDirected EvolvingGraph 0 nodes, 0 static edges, 0 timestamps\n\njulia> add_bunch_of_edges!(g, [(1,2,2001),(3,4,2008),(5,6,2007),(2,1,2003)])\nDirected EvolvingGraph 6 nodes, 4 static edges, 4 timestamps\n\njulia> edges(g)\n4-element Array{EvolvingGraphs.WeightedTimeEdge{EvolvingGraphs.Node{Int64},Int64,Float64},1}:\n Node(1)-1.0->Node(2) at time 2001\n Node(3)-1.0->Node(4) at time 2008\n Node(5)-1.0->Node(6) at time 2007\n Node(2)-1.0->Node(1) at time 2003\n\njulia> sort_timestamps!(g)\nDirected EvolvingGraph 6 nodes, 4 static edges, 4 timestamps\n\njulia> edges(g)\n4-element Array{EvolvingGraphs.WeightedTimeEdge{EvolvingGraphs.Node{Int64},Int64,Float64},1}:\n Node(1)-1.0->Node(2) at time 2001\n Node(2)-1.0->Node(1) at time 2003\n Node(5)-1.0->Node(6) at time 2007\n Node(3)-1.0->Node(4) at time 2008\n\n\n\n"
},

{
    "location": "algorithms.html#EvolvingGraphs.sort_timestamps",
    "page": "Algorithms",
    "title": "EvolvingGraphs.sort_timestamps",
    "category": "function",
    "text": "sort_timestamps(g)\n\nSort evolving graph g according to timestamps, return a new sorted evolving graph.\n\n\n\n"
},

{
    "location": "algorithms.html#EvolvingGraphs.slice_timestamps!",
    "page": "Algorithms",
    "title": "EvolvingGraphs.slice_timestamps!",
    "category": "function",
    "text": "slice_timestamps!(g, t_min, t_max)\n\nSlice an (sorted) evolving graph g between timestamp t_min and t_max.\n\n\n\n"
},

{
    "location": "algorithms.html#EvolvingGraphs.slice_timestamps",
    "page": "Algorithms",
    "title": "EvolvingGraphs.slice_timestamps",
    "category": "function",
    "text": "slice_timestamps(g, t_min, t_max)\n\nSlice an (sorted) evolving graph g between timestamp t_min and t_max., return a new evolving graph.\n\njulia> using EvolvingGraphs\n\njulia> g = EvolvingGraph()\nDirected EvolvingGraph 0 nodes, 0 static edges, 0 timestamps\n\njulia> add_bunch_of_edges!(g, [(1,2,1), (2,3,1), (1,4,2), (2,3,3), (3,4,5)])\nDirected EvolvingGraph 4 nodes, 5 static edges, 4 timestamps\n\njulia> g2 = slice_timestamps(g, 2,3)\nDirected EvolvingGraph 4 nodes, 2 static edges, 2 timestamps\n\njulia> edges(g)\n5-element Array{EvolvingGraphs.WeightedTimeEdge{EvolvingGraphs.Node{Int64},Int64,Float64},1}:\n Node(1)-1.0->Node(2) at time 1\n Node(2)-1.0->Node(3) at time 1\n Node(1)-1.0->Node(4) at time 2\n Node(2)-1.0->Node(3) at time 3\n Node(3)-1.0->Node(4) at time 5\n\njulia> edges(g2)\n2-element Array{EvolvingGraphs.WeightedTimeEdge{EvolvingGraphs.Node{Int64},Int64,Float64},1}:\n Node(1)-1.0->Node(4) at time 2\n Node(2)-1.0->Node(3) at time 3\n\n\n\n"
},

{
    "location": "algorithms.html#Sort-and-Slice-1",
    "page": "Algorithms",
    "title": "Sort and Slice",
    "category": "section",
    "text": "EvolvingGraphs.issorted\nEvolvingGraphs.sort_timestamps!\nEvolvingGraphs.sort_timestamps\nEvolvingGraphs.slice_timestamps!\nEvolvingGraphs.slice_timestamps"
},

]}
