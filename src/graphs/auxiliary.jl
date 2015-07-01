# auxiliary functions or types for working with AbstractEvolvingGraph

# whether the evolving graph has attributes
_has_attribute(g::AbstractEvolvingGraph) = typeof(g) <: AttributeEvolvingGraph ? true : false

typealias NodeVector{V} Vector{Node{V}}
