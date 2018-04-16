EvolvingGraphs Release Notes
=============================

v0.2.0
---------

* Only support julia v0.6 or above.
* Use Documenter.jl for Documentation.
* Breaking changes:
   - using `EvolvinGraph`, `MatrixList`, `Node`, `Edge`, `TimeNode`, `TimeEdge` to construct data.
	 - `matrix` and `spmatrix` are renamed to `adjacency_matrix` and `sparse_adjacency_matrix`.
	 - `rev` is renamed to `edge_reverse`.

v0.1.0
---------

* Drop support for Julia v0.3

* Bug fixes and performance improvements.

v0.0.9
------

* Fix test failing on Julia v0.3


v0.0.8
-------

* define function `matrix` for static graphs

* fix `add_edge!` error for `IntEvolvingGraph`.

* add functions for plotting: `plot` and `save_svg`

* fix Julia v0.4 deprecation

v0.0.7
-------

* Introduce two graph types:

	- `IntEvolvingGraph`: an evolving graph with integer nodes and timestamps.
	- `MatrixList`: a list of adjacency matrices

* rename the function `time` (defined for TimeNode, TimeEdge, TimeGraph) to `timestamp`.

v0.0.6
-----------

* new data type

	- `AggregatedGraph`
	- `AttributeNode`

* redefine `out_neighbors` to fix the shortest temporal path
  mistake. This change will affect the results of
  `shortest_temporal_path` and `weak_connected_components`.

* redefine type hierarchy, introduce abstraction `AbstractStaticGraph`.

* define function `eltype` on node types.

* new functions:

	- `undirected` and `undirected!` turns a directed evolving graph to an undirected
		evolving graph.


v0.0.5
----------

* new methods:

	- `add_edge!(g, [v1,...], [v2,...], t)` add multiple edges

	- `slice(g, [node1, node2,...])` slice the evolving graph
      according the given nodes.

	- `sorted` option for `katz_centrality`

* new functions:

	- `attributes_values(g, attrbute_key)` returns the values of
	  the given keys of the graph attributes.

	- `egwrite(g)` : write an evolving graph to file

	- `rm_edge!(g, v1, v2, t)` remove an edge from the evolving graph `g`.

	- `has_edge(g, v1, v2, t)` if graph `g` has an edge from `v1` to
      `v2` at time `t`.

	- `temporal_efficiency(g, (v1, t1), (v2, t2))`

	- `global_temporal_efficiency(g, t1, t2)`

* graph components

	- `temporal_connected(g, (v1, t1), (v2, t2))`

	- `weak_connected(g, v1, v2)`

	- `weak_connected_components(g, valuesonly = true)`

* update examples at README


v0.0.4
-------

* new metrics:

	- `shortest_path(g, v1, v2)`

	- `shortest_distance(g, v1, v2)`

	- `shortest_temporal_path(g, (v1, t1), (v2, t2))`

	- `shortest_temporal_distance(g, (v1, t1), (v2, t2))`

* new functions:

    - `has_node(g, v, t)`

	- `out_neighbors(g, v, t)`

	- slicing: `slice(g, t_min, t_max)` and `slice!(g, t_min, t_max)`

	- sorting: `issorted(g)`, `sorttime(g)` and `sorttime!(g)`

* tutorial for analyzing evolving graphs


v0.0.3
------

* add `egread` for inputting data

* define new types:

  - `AttributeTimeEdge`

  - `AttributeEvolvingGraph`

* add usage examples:

  - Working with Evolving Graphs

  - Working with Attribute Evolving Graphs

  - Inputting Data

v0.0.2
------

Use Docile.jl for documentation.


v0.0.1
------

Initial release.
