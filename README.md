# EvolvingGraphs

[![Build Status](https://travis-ci.org/weijianzhang/EvolvingGraphs.jl.svg?branch=master)](https://travis-ci.org/weijianzhang/EvolvingGraphs.jl)

*EvolvingGraph.jl* is a Julia package that provides data types and 
algorithms for working with evolving graphs.

**Installation** ``Pkg.add("EvolvingGraphs")``

**Documentation:** [Read the Docs](http://evolvinggraphsjl.readthedocs.org/en/latest/)


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

