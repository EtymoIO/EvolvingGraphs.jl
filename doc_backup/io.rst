Inputting & Outputting Data
===========================

Evolving Graph Format
---------------------

The Evolving Graph Format is an extended CSV format. The format files contains
three ordered sections:

1. *Header*. The first 15 characters must be `%%EvolvingGraph`. This
   is followed by a space and the type of the evolving graph: either `directed` or
   `undireced`.

2. *Comments*. Zero or more lines of comments. Each comment line
   starts with character `%`.

3. *Data*. The first line of this section is the header of the
   data. The first three header names are `i` and `j` and
   `timestamp`. It follows by other attributes. 


Evolving Graph Collection
-------------------------

A collection of evolving graphs arisen from real applications 
can be found at: http://www.maths.manchester.ac.uk/~weijian/EvolvingGraphDatasets/

Functions
---------

.. function:: egread(filename)

   reads the Evolving Graph Format file ``filename``. 

.. function:: egwrite(g, filename)

   writes an evolving graph graph ``g`` to file ``filename``. For example, 
   ``egwrite(g, example.csv)``.
