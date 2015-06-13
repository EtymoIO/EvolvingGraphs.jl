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

  - [x] metric
  - [x] Katz centrality
  - [ ] betweenness centrality
  - [x] random evolving graph

* io 

  - [x] read data from file with `egread`. (see the one in `data/`)
  - [x] write data to file with `egwrite`. 

* All data structures and algorithms are implemented in the Julia language.
