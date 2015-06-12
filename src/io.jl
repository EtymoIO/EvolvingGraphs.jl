
@doc doc"""
`egread(filename)` read the contents of an Evolving Graph format file. 
"""->
function egread(filename)
    file = open(filename, "r")
    firstline = chomp(readline(file))
    tokens = split(firstline)
    if tokens[1] != "%%EvolvingGraph"
        throw(ParseError("Not a valid EvolvingGraph header"))
    end
    is_directed = tokens[2] == "directed" ? true : false
    
    # skip all comments and empty lines
    ll = readline(file)

    while (length(ll) > 0 && ll[1] == '%')
        ll = readline(file)
    end
    
    header = split(chomp(ll), ',')
  
    length(header) >= 3 || error("The length of header must be >= 3") 
    
                  
    evolving_graph = length(header) == 3 ? true : false

    ilist = Any[]
    jlist = Any[]
    timestamps = Any[]

    if evolving_graph
        entries = split(chomp(readline(file)), ',')
        while length(entries) == 3
            push!(ilist, entries[1])
            push!(jlist, entries[2])
            push!(timestamps, entries[3])
            entries = split(chomp(readline(file)), ',')
        end       
        
        # try parse nodes and timestamps as Integer.
        try 
            ilist = [parse(Int64, s) for s in ilist]
            jlist = [parse(Int64, s) for s in jlist]
        end

        try 
            timestamps = [parse(Int64, s) for s in timestamps]
        end
     
        g = EvolvingGraph(is_directed, ilist, jlist, timestamps)
    else
        attributesvec = Dict[]
        entries = split(chomp(readline(file)), ',')

        while length(entries) >= 4           
            push!(ilist, entries[1])
            push!(jlist, entries[2])
            push!(timestamps, entries[3])
            push!(attributesvec, Dict(zip(header[4:end], entries[4:end])))
            entries = split(chomp(readline(file)), ',')
        end
        
        # try parse nodes and timestamps as Integer.
        try 
            ilist = [parse(Int64, s) for s in ilist]
            jlist = [parse(Int64, s) for s in jlist]
        end

        try 
            timestamps = [parse(Int64, s) for s in timestamps]
        end
        
        g = AttributeEvolvingGraph(is_directed, ilist, jlist, timestamps, attributesvec)
    end
    g
end

function _egwrite(io::IO, g::AbstractEvolvingGraph)
    header = is_directed(g) ? "%%EvolvingGraph directed" : "%%EvolvingGraph undirected"
    write(io, "$(header)\n")
    firstline = "i,j,timestamps"

    n = length(g.ilist)

    if _has_attribute(g)
        names = keys(g.attributesvec[1])

        # assuming all edges have the same number of attributes
        write(io, "$(firstline),")
        write(io, "$(join(names, ','))\n")
        for i in 1:n
            edges = join([g.ilist[i], g.jlist[i], g.timestamps[i]], ',')
            write(io, "$(edges),")
            for key in names
                write(io, "$(g.attributesvec[i][key]),")
            end
            write(io,"\n")
        end     
    else
        write(io, "$(firstline)\n")
        for i in 1:n
            edges = join([g.ilist[i], g.jlist[i], g.timestamps[i]], ',')
            write(io, "$(edges)\n")
        end
    end
        
end

function egwrite(g::AbstractEvolvingGraph, fn::AbstractString)
    f = open(fn, "w")
    _egwrite(f, g)
    close(f)
end
