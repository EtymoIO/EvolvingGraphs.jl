Examples
========

We can specify the two lists of nodes ``a`` and ``b`` and a list of 
time stamps ``c``, so that ``(a[i], b[i], c[i])`` is a ``TimeEdge``, i.e., 
there is edge from ``a[i]`` to ``b[i]`` at time ``c[i]``. 

Here is simple example. Suppose we define a function
``build_evolving_graph`` as follows::

  function build_evolving_graph(;is_directed = true)
    a = [1, 2, 3, 3, 4, 2, 6]
    b = [2, 3, 2, 5, 3, 5, 1]
    times = [1, 2, 2, 2, 3, 3, 3]
    return evolving_graph(a, b, times, is_directed = is_directed)
  end

Then we can generate an ``EvolvingGraph`` with::

  julia> g = build_evolving_graph()
  Directed IntEvolvingGraph (6 nodes, 7 edges, 3 timestamps)

and convert it an adjacency tensor with::

  julia> adjacency_tensor(g)
  6x6x3 Array{Bool,3}:
  [:, :, 1] =
  false   true  false  false  false  false
  false  false  false  false  false  false
  false  false  false  false  false  false
  false  false  false  false  false  false
  false  false  false  false  false  false
  false  false  false  false  false  false

  [:, :, 2] =
  false  false  false  false  false   true
  false  false   true  false  false  false
  false   true  false  false   true  false
  false  false  false  false  false  false
  false  false  false  false  false  false
  false  false  false  false  false  false

  [:, :, 3] =
  false  false  false  false  false  false
  false  false  false  false   true  false
  false  false  false  false  false  false
  false  false   true  false  false  false
  false  false  false  false  false  false
  true   false  false  false  false  false



