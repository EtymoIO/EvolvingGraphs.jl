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

TODO
----

* plotting evolving graphs



