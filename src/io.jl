# input data from a text file with each row is of the form 
# i    j   [w]  timestamp

"""
Read the contents of the Evolving Graph format file into a 
EvolvingGraph type.

"""
function egreader(filename)
    egfile = open(filename, "r")
    # Read the first line
    firstline = chomp(readline(egfile))
    tokens = split(firstline)
    if tokens[1] != "%%EvolvingGraph"
        throw(ParseError("Not a valid EvolvingGraph header"))
    end
    (object, nodetype, timetype) = map(lowercase, tokens[2:4])
    is_directed = object == "directed" ? true : false

    # skip all comments and empty lines
    ll = readline(egfile)
    while length(chomp(ll)) == 0 || (length(ll) > 0 && ll[1] == '%')
        ll = readline(egfile)
    end

    dd = map(x -> parse(Int, x), split(ll))
    if length(dd) < 3
        throw(ParseError(string("Could not read in EvolvingGraph dimensions from line: ", ll)))
    end
    edges = dd[1]
    nodes = dd[2]
    times = dd[3]

    if nodetype == "integer" && timetype == "integer"
        ilist = Array(Int, edges)
        jlist = Array(Int, edges)
        timestamps = Array(Int, edges)
        for i in 1:edges
            entries = split(readline(egfile))
            ilist[i] = parse(Int, entries[1])
            jlist[i] = parse(Int, entries[2])
            timestamps[i] = parse(Int, entries[3])
        end
        return EvolvingGraph(is_directed, ilist, jlist, timestamps) 
    end
    
end
