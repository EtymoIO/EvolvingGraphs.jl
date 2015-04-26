Nodes and Edges
===============

Node Types
----------

There are three node types: ``Node``, ``IndexNode`` and
``TimeNode``. The definition of ``Node`` is::

  immutable Node{T}
    Key::T
  end
 
The definition of ``IndexNode`` is::

  immutable IndexNode{T}
    index::Int
    key::T
  end

The definition of ``TimeNode`` is::

  immutable TimeNode{K,T}
    index::Int
    key::K
    time::T
  end

.. function:: key(v)

   return the key of a node ``v``, where ``v`` could be ``Node``,
   ``IndexNode`` or ``TimeNode``. 

.. function:: index(v)
	   
   return the index of a node ``v``. ``index`` is defined for 
   ``IndexNode`` and ``TimeNode``.


.. function:: time(v)

   return the time of node ``v``.	 


Edge Types
----------

There are two edge types in the collection. The definition of ``Edge``
is::

  immutable Edge{V}
    source::V
    target::V        
  end

The definition of ``TimeEdge`` is::

  immutable TimeEdge{K,T}
    source::K
    target::K
    time::T
  end

.. function:: source(e [, g])
	    
   return the source of the edge ``e``, where ``e`` could be either
   ``Edge`` or ``TimeEdge`` and ``g`` is a graph.


.. function:: target(e [, g])

   return the target of the edge ``e``, where ``g`` is a graph.

.. function:: time(e)

   return the time of a ``TimeEdge`` type ``e``.
