EvolvingGraphs Release Notes
============================

v0.0.1
------

Initial release.

v0.0.2
------

Use Docile.jl for documentation.

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


v0.0.5 (Working in Progress)
-----------------------------

* new methods:

	- `add_edge!(g, [v1,...], [v2,...], t)` add multiple edges

	- `attributes(g, attr_key)`

	- `slice(g, f)`, where `f` returns true,
		for example `slice(g, attr_key in attributes)`
			
	- `sorted` option for `katz_centrality` 

* new functions:
	
	- `set_attribute!(g, v1, v2, t)`

	- `egwrite(g)` : write an evolving graph to file

	- `rm_edge!(g, v1, v2, t)` remove an edge from the graph `g`.

	- `has_edge(g, v1, v2, t)` if graph `g` has edge `v1`.

	- `temporal_efficiency(g, (v1, t1), (v2, t2))`

	- `global_temporal_efficiency(g, t1, t2)`

* update examples at README

* add examples: building and analyzing citation networks

TODO
----

* plotting evolving graphs



