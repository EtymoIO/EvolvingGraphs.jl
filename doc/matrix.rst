Matrix Representation
=====================

TimeTensor
----------

Sometimes it is convenient to work with matrices and that is why we
provide a ``TimeTensor`` type. Here is the definition::

  immutable TimeTensor{T, M} <: AbstractTensor
    is_directed::Bool
    times::Vector{T}
    matrices::Vector{Matrix{M}}
  end

The following functions are defined on ``TimeTensor`` 

.. function:: time_tensor(g)
	      
   convert ``g`` from ``EvolvingGraph`` to ``TimeTensor``.

.. function:: is_directed(g)
	      
   return ``true`` if graph ``g`` is a directed graph and ``false``
   otherwise.

.. function:: matrices(g)

   return a list of adjacency matrices in ``g``.

.. function:: num_matrices(g)

   return the number of adjacency matrices in ``g``.

.. function:: timestamps(g)

   return the time stamps of graph ``g``.

.. function:: num_timestamps(g)
 
   return the number of time stamps of graph ``g``.


SparseTimeTensor
----------------

Here is the definition of ``SparseTimeTensor``::

  type SparseTimeTensor{T} <: AbstractTensor
    is_directed::Bool
    times::Vector{T}
    matrices::Vector{SparseMatrixCSC}
  end

Note the only difference from ``TimeTensor`` is that ``matrices`` are
stored as a vector of sparse matrices.
