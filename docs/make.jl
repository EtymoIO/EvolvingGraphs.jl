using Documenter, EvolvingGraphs, EvolvingGraphs.Centrality

makedocs(
    format=:html,
    sitename="EvolvingGraphs.jl",
    modules=[EvolvingGraphs, EvolvingGraphs.Centrality],
    pages=["index.md", "base.md", "graph_types.md", "centrality.md", "examples.md", "read_write.md"]
)

deploydocs(
    branch = "gh-pages",
    latest = "master",
    julia = "0.6",
    repo = "EtymoIO/EvolvingGraphs.jl"
)
