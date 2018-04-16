
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
    ilist = String[]
    jlist = String[]
    timestamps = String[]

    entries = split(chomp(readline(file)), ',')
    while length(entries) == 3
        push!(ilist, string(entries[1]))
        push!(jlist, string(entries[2]))
        push!(timestamps, string(entries[3]))
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
    return evolving_graph_from_arrays(ilist, jlist, timestamps, is_directed = is_directed)
end

function _egwrite(io::IO, g::AbstractEvolvingGraph)
    header = is_directed(g) ? "%%EvolvingGraph directed" : "%%EvolvingGraph undirected"
    write(io, "$(header)\n")
    firstline = "i,j,timestamps"

    n = num_edges(g)
    write(io, "$(firstline)\n")
    for i in 1:n
        es = g.edges[i]
        edges = join([source(es), target(es), edge_timestamp(es)], ',')
        write(io, "$(edges)\n")
    end
end


@doc doc"""
`egwrite(g, fn)` writes an evolving graph `g` to file `fn`. For example,
`egwrite(g, ""example.csv"")`.
"""->
function egwrite(g::AbstractEvolvingGraph, fn::AbstractString)
    f = open(fn, "w")
    _egwrite(f, g)
    close(f)
end
