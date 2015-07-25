# the show function 
function show(io::IO, v::Node)
    print(io, "Node($(v.key))")
end

function show(io::IO, v::AttributeNode)
    print(io, "AttributeNode($(v.key))")
end

function show(io::IO, v::TimeNode)
    print(io, "TimeNode($(v.key), $(v.time))")
end

function show(io::IO, e::Edge)
    print(io, "Edge $(e.source)->$(e.target)")
end
 
function show(io::IO, e::TimeEdge)
    print(io, "TimeEdge($(e.source)->$(e.target)) at time $(e.time)")
end

function show(io::IO, e::WeightedTimeEdge)
    print(io, "WeightedTimeEdge($(e.source)-$(e.weight)->$(e.target)) at time $(e.time)")
end

function show(io::IO, e::AttributeTimeEdge)
    print(io, "AttributeTimeEdge($(e.source)->$(e.target)) at time $(e.time)")
end

function show(io::IO, g::EvolvingGraph)
    title = is_directed(g) ? "Directed EvolvingGraph" : "Undirected EvolvingGraph"
    print(io, "$(title) ($(num_nodes(g)) nodes, $(num_edges(g)) edges, $(num_timestamps(g)) timestamps)")
end

function show(io::IO, g::IntEvolvingGraph)
    title = is_directed(g) ? "Directed IntEvolvingGraph" : "Undirected IntEvolvingGraph"
    print(io, "$(title) ($(num_nodes(g)) nodes, $(num_edges(g)) edges, $(num_timestamps(g)) timestamps)")
end

function show(io::IO, g::WeightedEvolvingGraph)
    title = is_directed(g) ? "Directed WeightedEvolvingGraph" : "Undirected WeightedEvolvingGraph"
    print(io, "$(title) ($(num_nodes(g)) nodes, $(num_edges(g)) edges, $(num_timestamps(g)) timestamps)")
end

function show(io::IO, g::AttributeEvolvingGraph)
    title = is_directed(g) ? "Directed AttributeEvolvingGraph" : "Undirected AttributeEvolvingGraph"
    print(io, "$(title) ($(num_nodes(g)) nodes, $(num_edges(g)) edges, $(num_timestamps(g)) timestamps)")
end

function show(io::IO, g::TimeGraph)
    title = is_directed(g) ? "Directed TimeGraph" : "Undirected TimeGraph"
    print(io, "$(title) ($(num_nodes(g)) nodes, $(num_edges(g)) edges)")
end


function show(io::IO, g::AggregatedGraph)
    title = is_directed(g)? "Directed AggregatedGraph" : "Undirected AggregatedGraph"
    print(io, "$(title) ($(num_nodes(g)) nodes, $(num_edges(g)) edges)")
end

function show(io::IO, g::MatrixList)
    title = is_directed(g)? "Directed MatrixList" : "Undirected MatrixList"
    print(io, "$(title) ($(num_nodes(g)) nodes, $(num_matrices(g)) matrices)")
end   

function show(io::IO, p::AbstractPath)
    title = typeof(p) == Path ? "Path" : "Temporal Path"
    result = ""
    for i in 1:length(p)
        if i == length(p) 
            result = string(result, p.walks[i])
        else
            result = string(result, p.walks[i], "->")
        end
    end   
    print(io, "$(title) ($(max(length(p) - 1, 0)) walks) $(result)")
end
