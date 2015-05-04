# EvolvingGraphs

[![Build Status](https://travis-ci.org/weijianzhang/EvolvingGraphs.jl.svg?branch=master)](https://travis-ci.org/weijianzhang/EvolvingGraphs.jl)

*EvolvingGraph.jl* is a Julia package that provides data types and 
algorithms for working with evolving graphs.

**Installation:** ``Pkg.add("EvolvingGraphs")``

**Documentation:** [Read the Docs](http://evolvinggraphsjl.readthedocs.org/en/latest/)

## Features

Here are the main features:

* A variety of data types for working with evolving graphs.

  - [x] TimeEdge
  - [x] EvolvingGraph     
  - [x] WeightedEvolvingGraph

* A collection of evolving graph algorithms.

  - [ ] metric
  - [x] Katz centrality
  - [ ] betweenness centrality
  - [x] random evolving graph

* io 

  - [x] read data in Evolving Graph Exchange Format. (see the one in `data/`)
  - [ ] write a graph in Evolving Graph Exchange Format. 

* All data structures and algorithms are implemented in *pure Julia*.

## Examples

Generate a random evolving graph with 4 nodes and 3 timestamps:

```julia
	julia> g = random_evolving_graph(4, 3)
	Directed IntEvolvingGraph (4 nodes, 17 edges, 3 timestamps)
```

Find the timestamps of `g`:

```julia
	julia> timestamps(g)
	3-element Array{Int64,1}:
	1
	2
	3
```
Get an adjacency matrix representation at each timestamp:

```julia
	julia> matrix(g, 1)
	4x4 Array{Bool,2}:
	false   true   true   true
	true   false   true  false
	true   false  false  false
	false  false  false  false

	julia> matrix(g, 2)
	4x4 Array{Bool,2}:
	false  true   true   true
	false false  false   true
	true  false  false  false
	true   true  false  false

	julia> matrix(g, 3)
	4x4 Array{Bool,2}:
	false  false  false  false
	true   false  false   true
	false  false  false  false
	true   true   false  false
```
