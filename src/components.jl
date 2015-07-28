# _breath_first_visit(g, (v1, t1))
# find all reachable nodes from (v1, t1)
function _breath_first_visit(g::AbstractEvolvingGraph, s::Tuple)
    level = @compat Dict(s => 0)
    i = 1
    fronter = [s]
    reachable = [s]
    while length(fronter) > 0
        next = Tuple[]
        for u in fronter
            for v in out_neighbors(g, u)
                if !(v in keys(level))
                    level[v] = i
                    push!(reachable, v)
                    push!(next, v)
                end
            end
        end
        fronter = next
        i += 1
    end
    reachable
end

@doc doc"""
`temporal_connected(g, (v1, t1), (v2, t2))` returns `true` if there is path 
from `v1` at timestamp `t1` to `v2` at timestamp `t2` and `false` otherwise.
"""->
temporal_connected(g::AbstractEvolvingGraph, v1::Tuple, v2::Tuple) = 
               v2 in _breath_first_visit(g, v1) ? true : false 

# true = 1, false = 0

@doc doc"""
`weak_connected(g, v1, v2)` returns `true` if there is a temporal path 
from `v1` to `v2` at any timestamps.
"""->
function weak_connected(g::AbstractEvolvingGraph, v1, v2) 
    sum = false
    ts = timestamps(g)
    n = length(ts)
    for i in 1:n
        for j in i:n
            sum += temporal_connected(g, (v1, ts[i]), (v2, ts[j]))
          #  println("sum:", sum)
        end
    end
    return sum > 0 ? true : false
end



@doc doc"""
`weak_connected_components(g, valuesonly = true)` finds the weakly connected components
of an evolving graph `g`, i.e, each node in the set is weakly 
connected to all the other nodes. If valuesonly = false, returns a dictionary with the starting  
the search as dictionary key.
"""->
function weak_connected_components{V}(g::AbstractEvolvingGraph{V}, valuesonly::Bool = true)
    components = Dict{Tuple, Vector{Tuple}}()
    nodelist = V[]
    reachable = Tuple[]
    
    t = timestamps(g)
    n = length(t)

    for node in nodes(g)     
        i = 1
        if ! ( node  in nodelist)
   
            reachable = _breath_first_visit(g, (node, t[i]))
             while length(reachable) == 1
                if i < n
                    i += 1
                else
                    break
                end
                reachable = _breath_first_visit(g, (node, t[i]))
            end

            append!(nodelist, map(x -> x[1], reachable))
            
            #println("components:", components)
            components[(node, t[i])] = reachable
            
            ks = keys(components)
          
            for node2 in ks
                if !(node2 == (node, t[i])) && (temporal_connected(g, (node, t[i]), node2))
                    components[node2] = reachable
                    delete!(components, (node, t[i]))
                end
            end
        end
    end
    if valuesonly
        return collect(values(components))
    else
        return components
    end
end
