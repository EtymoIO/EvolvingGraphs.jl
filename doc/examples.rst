Getting Started
===============

After installation, the first thing to do is to type::

  julia> using EvolvingGraphs


Suppose we have an evolving network with 2 timestamps 
:math:`t_1, t_2` as shown in the figure below.

.. image:: eg1.png

To represent this evolving network, we can first build two graphs at
time :math:`t_1` and :math:`t_2` with the function ``time_graph``::

  julia> g1 = time_graph(Char, "t1")
  Directed TimeGraph (0 nodes, 0 edges)

  julia> add_edge!(g1, 'a', 'b')
  Directed TimeGraph (2 nodes, 1 edges)

  julia> add_edge!(g1, 'a', 'c')
  Directed TimeGraph (3 nodes, 2 edges)

  julia> g2 = time_graph(Char, "t2")
  Directed TimeGraph (0 nodes, 0 edges)

  julia> add_edge!(g2, 'b', 'c')
  Directed TimeGraph (2 nodes, 1 edges)

and then build an evolving graph ``eg`` by combining ``g1`` and ``g2``::

  julia> eg = evolving_graph(Char, String)
  Directed EvolvingGraph (0 nodes, 0 edges, 0 timestamps)

  julia> add_graph!(eg, g1)
  Directed EvolvingGraph (3 nodes, 2 edges, 1 timestamps)

  julia> add_graph!(eg, g2)
  Directed EvolvingGraph (3 nodes, 3 edges, 2 timestamps)

Now ``eg`` is a directed evolving graph with 3 nodes, 3 edges and 2 
timestamps. We can retrieve information from ``eg``::

  julia> nodes(eg)
  3-element Array{Char,1}:
  'a'
  'b'
  'c'

  julia> edges(eg)
  3-element Array{EvolvingGraphs.TimeEdge{V,T},1}:
  TimeEdge(a->b) at time t1
  TimeEdge(a->c) at time t1
  TimeEdge(b->c) at time t2

  julia> timestamps(eg)
  2-element Array{AbstractString,1}:
  "t1"
  "t2"

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

We can also convert an ``EvolvingGraph`` to ``TimeTensor``::

  julia> tt = time_tensor(g)
  Directed TimeTensor (3 matrices, 3 timestamps)

Notice ``TimeTensor`` store graph data as a vector of matrices::

  julia> matrices(tt)
  3-element Array{Array{Bool,2},1}:
  6x6 Array{Bool,2}:
  false   true  false  false  false  false
  false  false  false  false  false  false
  false  false  false  false  false  false
  false  false  false  false  false  false
  false  false  false  false  false  false
  false  false  false  false  false  false
  6x6 Array{Bool,2}:
  false  false  false  false  false  false
  false  false   true  false  false  false
  false   true  false  false   true  false
  false  false  false  false  false  false
  false  false  false  false  false  false
  false  false  false  false  false  false
  6x6 Array{Bool,2}:
  false  false  false  false  false  false
  false  false  false  false   true  false
  false  false  false  false  false  false
  false  false   true  false  false  false
  false  false  false  false  false  false
  true   false  false  false  false  false

  
