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

v0.0.4 (Coming Soon)
--------------------

* metrics for analyzing evolving graphs:

	- shortest temporal distance
	- temporal efficiency

* new functions:

    - `has_node(g, v, t)`

	- `out_neighbors(g, v, t)`

	- slicing: `slice(g, t_min, t_max)` and `slice!(g, t_min, t_max)`

	- sorting: `issorted(g)`, `sorttime(g)` and `sorttime!(g)`


TODO
----

* plotting evolving graphs



