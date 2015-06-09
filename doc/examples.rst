Tutorial
========

Working with Evolving Graphs
----------------------------

We can initialize a simple evolving graph with integer nodes and edges by::

  julia> g = evolving_graph()
  Directed IntEvolvingGraph (0 nodes, 0 edges, 0 timestamps)

There is nothing in the graph ``g`` at the moment. To make it a little 
more interesting, we can add some edges to ``g``. We need to note that
edges have a time dimension in an evolving graph::

  julia> add_edge!(g, 1, 2, 1) 
  Directed IntEvolvingGraph (2 nodes, 1 edges, 1 timestamps)

This will add an edge from node ``1`` to node ``2`` at time ``1``. 
Let's add more edges to ``g``::

  julia> add_edge!(g, 2, 3, 1)
  Directed IntEvolvingGraph (3 nodes, 2 edges, 1 timestamps)

  julia> add_edge!(g, 2, 3, 2)
  Directed IntEvolvingGraph (3 nodes, 3 edges, 2 timestamps)

  julia> add_edge!(g, 2, 4, 2)
  Directed IntEvolvingGraph (4 nodes, 4 edges, 2 timestamps)

Now ``g`` has 4 nodes, 4 edges and 2 timestamps. Here are the edges we have::

  julia> edges(g)
  4-element Array{EvolvingGraphs.TimeEdge{V,T},1}:
  TimeEdge(1->2) at time 1
  TimeEdge(2->3) at time 1
  TimeEdge(2->3) at time 2
  TimeEdge(2->4) at time 2

We can also check the edges at a specific timestamp::

  julia> edges(g, 2)
  2-element Array{EvolvingGraphs.TimeEdge{V,T},1}:
  TimeEdge(2->3) at time 2
  TimeEdge(2->4) at time 2

We can think of an evolving graph as a list of adjacency matrices. 
In particular, at each timestamp ``g`` can be represented as an adjacency 
matrix::

  julia> matrix(g, 1)
  4x4 Array{Bool,2}:
  false   true  false  false
  false  false   true  false
  false  false  false  false
  false  false  false  false

  julia> matrix(g, 2)
  4x4 Array{Bool,2}:
  false  false  false  false
  false  false   true   true
  false  false  false  false
  false  false  false  false

where the ``(i,j)`` entry is ``true`` if there is an edge from
``nodes(g)[i]`` to ``nodes(g)[j]`` and ``false`` otherwise.  An
interesting fact is a degree 2 dynamic walk can be found by multiplying 
the two adjacency matrices::

  julia> matrix(g, 1) * matrix(g,2)
  4x4 Array{Int64,2}:
  0  0  1  1
  0  0  0  0
  0  0  0  0
  0  0  0  0

This shows there are two degree 2 dynamic walks: from node ``1`` to node ``3`` 
(via node ``2``) and from node ``1`` to node ``4`` (via node ``2``). 
   
Working with Attribute Evolving Graphs
--------------------------------------

Sometimes, we want not only to record the connectivity of nodes in an 
evolving graph but also to record **the degree of connectivity**. This can be 
achieved with attribute evolving graphs. Here is an example. Suppose 
we want to record the closeness between 3 people ``a``, ``b`` and ``c``
at different time, say ``January`` and ``February``::
    
  julia> g = attribute_evolving_graph(String, String, is_directed = false)
  Undirected AttributeEvolvingGraph (0 nodes, 0 edges, 0 timestamps)

  julia> add_edge!(g, "a", "b", "January", Dict("closeness" => 0.2))
  Undirected AttributeEvolvingGraph (2 nodes, 2 edges, 1 timestamps)

  julia> add_edge!(g, "a", "b", "February", Dict("closeness" => 0.8))
  Undirected AttributeEvolvingGraph (2 nodes, 4 edges, 2 timestamps)

  julia> add_edge!(g, "a", "c", "January", Dict("closeness" => 0.7))
  Undirected AttributeEvolvingGraph (3 nodes, 6 edges, 2 timestamps)

  julia> add_edge!(g, "a", "c", "February", Dict("closeness" => 0.2))
  Undirected AttributeEvolvingGraph (3 nodes, 8 edges, 2 timestamps)

  julia> add_edge!(g, "b", "c", "January", Dict("closeness" => 0.5))
  Undirected AttributeEvolvingGraph (3 nodes, 10 edges, 2 timestamps)

  julia> add_edge!(g, "b", "c", "February", Dict("closeness" => 0.5))
  Undirected AttributeEvolvingGraph (3 nodes, 12 edges, 2 timestamps)

Now the closeness of the 3 people at ``January`` and ``February`` can 
be represented as two weighted adjacency matrix::

  julia> matrix(g, "January", "closeness")
  3x3 Array{Float64,2}:
  0.0  0.2  0.7
  0.2  0.0  0.5
  0.7  0.5  0.0

  julia> matrix(g, "February", "closeness")
  3x3 Array{Float64,2}:
  0.0  0.8  0.2
  0.8  0.0  0.5
  0.2  0.5  0.0


Inputting Data 
--------------

There are two sample datasets at the directory ``data/``: 

* ``traffic20141201.csv`` is the Highways Agency network
  journey time and traffic flow data. 

* ``manunited_cont.csv`` is the Strathclyde MUFC Twitter Data Set.

More details of the datasets can be found at: https://github.com/weijianzhang/EvolvingGraphDatasets

We can input them with the function ``egread``::

  julia> twitterdata = joinpath(Pkg.dir("EvolvingGraphs"), "data", "manunited_cont.csv");
  julia> twitter = egread(twitterdata)
  Directed EvolvingGraph (148918 nodes, 298335 edges, 37581 timestamps)


Analyzing Evolving Graphs
-------------------------

Coming soon!
