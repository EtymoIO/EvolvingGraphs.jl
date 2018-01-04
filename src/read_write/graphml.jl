export load_graphml

"""
    load_graphml(filename)

Read a graphML format file with file name `filename`.
"""
function load_graphml(filename)
    open(EzXML.StreamReader, filename) do reader
        serial = 0
        nodes = []
        edges = Edge[]

        # scan nodes
        for typ in reader
            if typ == EzXML.READER_ELEMENT
                elname = EzXML.name(reader)
                if elname == "node"
                    push!(nodes, reader["id"])
                elseif elname == "edge"
                    e = Edge(reader["source"], reader["target"])
                    push!(edges, e)
                end
            end
        end
    return digraph(nodes, edges)
    end
end
