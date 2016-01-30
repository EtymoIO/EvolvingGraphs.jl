# EvolvingGraphs

[![Build Status](https://travis-ci.org/weijianzhang/EvolvingGraphs.jl.svg?branch=master)](https://travis-ci.org/weijianzhang/EvolvingGraphs.jl)
[![codecov.io](https://codecov.io/github/weijianzhang/EvolvingGraphs.jl/coverage.svg?branch=master)](https://codecov.io/github/weijianzhang/EvolvingGraphs.jl?branch=master)

Dynamic Graph Analysis Framework in Julia.

* Installation: ``Pkg.add("EvolvingGraphs")``

* [Documentation](http://evolvinggraphsjl.readthedocs.org/en/latest/)

* [Release Notes](https://github.com/weijianzhang/EvolvingGraphs.jl/blob/master/NEWS.md)

## Examples

![simple evolving graph](doc/example1.png)

We can generate the above evolving graph as

```julia
    g = evolving_graph(Int, AbstractString)
	add_edge!(g, 1, 2, "t1")
	add_edge!(g, 1, 3, "t2")
	add_edge!(g, 4, 5, "t2")
	add_edge!(g, 2, 3, "t3")
	add_edge!(g, 5, 6, "t3")
```
Now ``g`` is a directed evolving graph with
6 nodes, 5 edges and 3 timestamps.

```julia
	julia> g
	Directed EvolvingGraph (6 nodes, 5 edges, 3 timestamps)
```

We can find the weakly connected components and the shortest
temporal path of ``g``

```julia
	julia> weak_connected_components(g)
	2-element Array{Array{Tuple,1},1}:
	Tuple[(1,"t1"),(2,"t1"),(1,"t2"),(2,"t3"),(3,"t2"),(3,"t3")]
	Tuple[(4,"t2"),(5,"t2"),(5,"t3"),(6,"t3")]

	julia> shortest_temporal_path(g, (1, "t1"), (3, "t3"))
	Temporal Path (3 walks) (1,"t1")->(1,"t2")->(3,"t2")->(3,"t3")
```

We can also convert ``g`` to a list of adjacency matrices

```julia
	julia> matrix(g, "t2")
	6x6 Array{Bool,2}:
	false  false  false  false   true  false
	false  false  false   true  false  false
	false  false  false  false  false  false
	false  false  false  false  false  false
	false  false  false  false  false  false
	false  false  false  false  false  false

	julia> spmatrix(g, "t2")
	6x6 sparse matrix with 2 Bool entries:
	[2, 4]  =  true
	[1, 5]  =  true
```

where the `(i,j)` entry is `true` if there is an edge from
`nodes(g)[i]` to `nodes(g)[j]` and `false` otherwise. Here we have

```julia
	julia> nodes(g)[2]
	4
	
	julia> nodes(g)[4]
	5
	
	julia> nodes(g)[1]
	1
	
	julia> nodes(g)[5]
	3
```

and many [more things](http://evolvinggraphsjl.readthedocs.org/en/latest/tutorial.html).


## References

- Weijian Zhang,
  "Dynamic Network Analysis in Julia",
  *MIMS EPrint*, 2015.83, (2015).
  [[pdf]](http://eprints.ma.man.ac.uk/2376/01/covered/MIMS_ep2015_83.pdf)

- Jiahao Chen and Weijian Zhang,
  "The Right Way to Search Evolving Graphs",
  "MIMS EPrint", 2016.7, (2016)
  [[pdf]](http://eprints.ma.man.ac.uk/2435/01/covered/MIMS_ep2016_7.pdf)
