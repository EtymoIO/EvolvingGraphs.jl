# Graph Types

```@docs
EvolvingGraphs.AbstractGraph
EvolvingGraphs.AbstractEvolvingGraph
EvolvingGraphs.AbstractStaticGraph
```

## Evolving Graphs

```@docs
EvolvingGraphs.EvolvingGraph
EvolvingGraphs.evolving_graph_from_arrays
EvolvingGraphs.adjacency_matrix
EvolvingGraphs.sparse_adjacency_matrix
```

## Matrix List

```@docs
EvolvingGraphs.MatrixList
EvolvingGraphs.evolving_graph_to_matrices
EvolvingGraphs.matrices
EvolvingGraphs.num_matrices
```

## Adjacency List

```@docs
EvolvingGraphs.IntAdjacencyList
EvolvingGraphs.evolving_graph_to_adj
```

## Static Graphs

```@docs
EvolvingGraphs.DiGraph
EvolvingGraphs.out_edges
EvolvingGraphs.out_degree
EvolvingGraphs.in_edges
EvolvingGraphs.in_degree
EvolvingGraphs.aggregate_graph
```

## General Functions

```@docs
EvolvingGraphs.nodes
EvolvingGraphs.num_nodes
EvolvingGraphs.active_nodes
EvolvingGraphs.num_active_nodes
EvolvingGraphs.add_node!
EvolvingGraphs.find_node
EvolvingGraphs.edges
EvolvingGraphs.num_edges
EvolvingGraphs.add_edge!
EvolvingGraphs.add_bunch_of_edges!
EvolvingGraphs.is_directed
EvolvingGraphs.timestamps
EvolvingGraphs.unique_timestamps
EvolvingGraphs.num_timestamps
EvolvingGraphs.forward_neighbors
EvolvingGraphs.backward_neighbors
```
