"""
    temporal_connected(g, v1, t1, v2, t2) 

Return `true` if there is path from `v1` at timestamp `t1` to `v2` at 
timestamp `t2` and `false` otherwise.
"""
temporal_connected{V, T}(g::AbstractEvolvingGraph{V, T}, v1, t1, v2, t2) = 
     (v2, t2) in breadth_first_impl(g, v1, t1) ? true : false
function temporal_connected{V, T}(g::EvolvingGraph{V, T}, v1, t1, v2, t2)
    nv1 = find_node(g, v1)
    nv2 = find_node(g, v2)

    # check if v1 and v2 are nodes of the graph
    if nv1 == false || nv2 == false
        return false
    end

    if (nv2, T(t2)) in breadth_first_impl(g, nv1, T(t1))
        return true
    else
        return false
    end
end
"""
    weak_connected(g, v1, v2)

Return `true` if there is a temporal path from `v1` to `v2` at any timestamps.
"""
function weak_connected(g::AbstractEvolvingGraph, v1, v2) 
    sum = false
    ts = timestamps(g)
    n = length(ts)
    for i in 1:n
        for j in i:n
            sum += temporal_connected(g, v1, ts[i], v2, ts[j])
            if sum > 0
                return true
            end
        end
    end
    return false
end



"""
    weak_connected_components(g, valuesonly = true)

Find the weakly connected components of an evolving graph `g`, i.e, 
each node in the set is weakly connected to all the other nodes. 
If valuesonly = false, returns a dictionary with the starting  
the search as dictionary key.
"""
function weak_connected_components{V}(g::AbstractEvolvingGraph{V}, 
                                                                           valuesonly::Bool = true)
    components = Dict{Tuple, Vector{Tuple}}()
    nodelist = V[]
    reachable = Tuple[]
    
    t = timestamps(g)
    n = length(t)

    for n1 in nodes(g)     
        i = 1
        if ! (n1 in nodelist)
   
            reachable = breadth_first_impl(g, n1, t[i])
             while length(reachable) == 1
                 if i < n
                     i += 1
                 else
                     break
                 end
                 reachable = breadth_first_impl(g, n1, t[i])
            end

            append!(nodelist, map(x -> x[1], reachable))
            
            components[(n1, t[i])] = reachable
            ks = keys(components)

            for n2 in ks
                if !(n2 == (n1, t[i])) && 
                    (temporal_connected(g, n1, t[i], n2[1], n2[2]))
                    components[n2] = reachable
                    delete!(components, (n1, t[i]))
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
