"""
    temporal_connected(g, v1, t1, v2, t2) 

Return `true` if there is path from `v1` at timestamp `t1` to `v2` at 
timestamp `t2` and `false` otherwise.
"""
temporal_connected(g::AbstractEvolvingGraph, v1, t1, v2, t2) = 
     (v2, t2) in breadth_first_visit(g, v1, t1) ? true : false

function temporal_connected{V, E, T}(g::EvolvingGraph{V, E, T}, v1, t1, v2, t2)
    v1 = find_node(g, v1)
    v2 = find_node(g, v2)
    if (v2, T(t2)) in breadth_first_visit(g, v1, T(t1))
        return true
    else
        return false
    end
end  
# true = 1, false = 0

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

    for node in nodes(g)     
        i = 1
        if ! (node  in nodelist)
   
            reachable = breadth_first_visit(g, node, t[i])
             while length(reachable) == 1
                 if i < n
                     i += 1
                 else
                     break
                 end
                 reachable = breadth_first_visit(g, node, t[i])
                 println("while")
                 display(reachable)
            end

            append!(nodelist, map(x -> x[1], reachable))
            
            #println("components:", components)
            println("nodelist", nodelist)
            components[(node, t[i])] = reachable
            ks = keys(components)
            println("ks", ks)
            for node2 in ks
                if !(node2 == (node, t[i])) && 
                    (temporal_connected(g, node, t[i], node2[1], node2[2]))
                    components[node2] = reachable
                    delete!(components, (node, t[i]))
                    println("for")
                    display(components)
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
