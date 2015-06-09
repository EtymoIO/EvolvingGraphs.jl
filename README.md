# EvolvingGraphs

[![Build Status](https://travis-ci.org/weijianzhang/EvolvingGraphs.jl.svg?branch=master)](https://travis-ci.org/weijianzhang/EvolvingGraphs.jl)
| Julia 0.3 [![EvolvingGraphs](http://pkg.julialang.org/badges/EvolvingGraphs_release.svg)](http://pkg.julialang.org/?pkg=EvolvingGraphs&ver=release)
| Julia 0.4 [![EvolvingGraphs](http://pkg.julialang.org/badges/EvolvingGraphs_nightly.svg)](http://pkg.julialang.org/?pkg=EvolvingGraphs&ver=nightly)

Dynamic Graph Analysis Framework in Julia.

* Installation: ``Pkg.add("EvolvingGraphs")``

* [Documentation](http://evolvinggraphsjl.readthedocs.org/en/latest/)

* [Release Notes](https://github.com/weijianzhang/EvolvingGraphs.jl/blob/master/NEWS.md)

## Features

Here are the main features:

* A variety of data types for working with evolving graphs.

  - [x] TimeEdge
  - [x] EvolvingGraph
  - [X] AttributeEvolvingGraph
  - [x] WeightedEvolvingGraph

* A collection of evolving graph algorithms.

  - [ ] metric
  - [x] Katz centrality
  - [ ] betweenness centrality
  - [x] random evolving graph

* io 

  - [x] read data in Evolving Graph Exchange Format. (see the one in `data/`)


* All data structures and algorithms are implemented in the Julia language.

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
