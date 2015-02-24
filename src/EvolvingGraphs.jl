module EvolvingGraphs

import Base: ==, show

export 

# core
Node, Edge, AbstractEvolvingGraph 


include("core.jl")

  
include("graphs/adjacency_list.jl")
include("graphs/edge_list.jl")
include("graphs/tensor.jl")

end # module
