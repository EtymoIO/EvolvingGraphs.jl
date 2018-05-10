"""
    load_graphml(filename)

Read a graphML format file with file name `filename`.
Note: only support DiGraph{Node{String}} for now.
"""
function load_graphml(filename)
    open(EzXML.StreamReader, filename) do reader
        serial = 0
        g = DiGraph{Node{String}}()
        # scan nodes
        for typ in reader
            if typ == EzXML.READER_ELEMENT
                elname = EzXML.nodename(reader)
                if elname == "node"
                    add_node!(g, reader["id"])
                elseif elname == "edge"
                    add_edge!(g, reader["source"], reader["target"])
                end
            end
        end
    return g
    end
end
