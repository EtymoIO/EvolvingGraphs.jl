# EvolvingGraphs

[![Build Status](https://travis-ci.org/weijianzhang/EvolvingGraphs.jl.svg?branch=master)](https://travis-ci.org/weijianzhang/EvolvingGraphs.jl)

*EvolvingGraph.jl* is a Julia package that provides data types and 
algorithms for working with evolving graphs.

**Installation:**  `Pkg.clone("https://github.com/weijianzhang/EvolvingGraphs.jl.git")`

**Documentation:** [Read the Docs](http://evolvinggraphsjl.readthedocs.org/en/latest/)

Here are the main features:

* A variety of data types for working with evolving graphs.

  - [x] TimeEdge
  - [x] EvolvingGraph     
  - [x] WeightedEvolvingGraph

* State of the art algorithms for computing centrality on evolving graphs. 

  - [ ] metric
  - [x] Katz centrality
  - [ ] betweenness centrality

* io 

  - [x] read in Evolving Graph Exchange Format file
  - [ ] write a graph in Evolving Graph Exchange Format. 

* All data structures and algorithms are implemented in *pure Julia*.

