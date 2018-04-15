# the show function
function show(io::IO, v::Node)
    print(io, "Node($(v.key))")
end

function show(io::IO, v::AttributeNode)
    print(io, "AttributeNode($(v.key))")
end

function show(io::IO, v::TimeNode)
    print(io, "TimeNode($(v.key), $(v.timestamp))")
end

function show(io::IO, e::Edge)
    print(io, "$(e.source)->$(e.target)")
end

function show(io::IO, e::TimeEdge)
    print(io, "$(e.source)->$(e.target) at time $(e.timestamp)")
end

function show(io::IO, e::WeightedTimeEdge)
    print(io, "$(e.source)-$(e.weight)->$(e.target) at time $(e.timestamp)")
end

function show{V, E}(io::IO, g::DiGraph{V, E})
    print(io, "DiGraph $(num_nodes(g)) nodes, $(num_edges(g)) edges")
end

function show{V, E, T, KV}(io::IO, g::EvolvingGraph{V, E, T, KV})
    title = is_directed(g) ? "Directed EvolvingGraph" : "Undirected EvolvingGraph"
    print(io, "$(title) $(num_nodes(g)) nodes, $(num_edges(g)) static edges, $(num_timestamps(g)) timestamps")
end

function show(io::IO, g::IntAdjacencyList)
    title = is_directed(g) ? "Directed IntAdjacencyList" : "Undirected IntAdjacencyList"
    print(io, "$(title) ($(num_nodes(g)) nodes, $(num_edges(g)) static edges, $(num_timestamps(g)) timestamps)")
end



function show(io::IO, g::MatrixList)
    print(io, "MatrixList ($(num_matrices(g)) matrices)")
end


function show(io::IO, p::AbstractPath)
    result = ""
    for i in 1:length(p)
        if i == length(p)
            result = string(result, p.nodes[i])
        else
            result = string(result, p.nodes[i], "->")
        end
    end
    print(io, "$(result)")
end
