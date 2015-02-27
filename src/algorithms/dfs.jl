# Depth first search
function print_path(path)
    print("path: ")
    for i in 1 : length(path)-1
        print(path[i], " -> ")
    end
    print(path[end])
    print("\n")
end

function DFS(g::AdjacencyList, start_node::Node, end_node::Node, 
                   path = Node[], shortest = None) 
   
    path = cat(1, path, [start_node])
    print_path(path)

    if start_node == end_node # terminates the recursion
        return path
    end
    
    for node in out_neighbors(g, start_node)
        if !(node in path) # avoid cycles
            if shortest == None || length(path) < length(shortest) 
                newPath = DFS(g, node, end_node, path, shortest)
                if newPath != None
                    shortest = newPath
                end
            end
        end
    end
    return shortest
end

