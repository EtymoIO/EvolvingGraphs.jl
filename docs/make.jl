using Documenter, EvolvingGraphs, EvolvingGraphs.Centrality

makedocs(
    format=:html,
    sitename="EvolvingGraphs.jl",
    modules=[EvolvingGraphs, EvolvingGraphs.Centrality],
    pages=["base.md", "graph_types.md", "centrality.md", "examples.md", "read_write.md"]
)

deploydocs(
    branch = "gh-pages",
    latest = "master",
    repo = "EtymoIO/EvolvingGraphs.jl"
)
