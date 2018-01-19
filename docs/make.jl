using Documenter, EvolvingGraphs, EvolvingGraphs.Centrality

makedocs(
    format=:html,
    sitename="EvolvingGraphs.jl",
    modules=[EvolvingGraphs, EvolvingGraphs.Centrality],
    pages=[
    "Home" =>"index.md",
    "Manual" => ["base.md",
                "graph_types.md",
                "centrality.md",
                "examples.md",
                "read_write.md"
                ]
    ]
)

deploydocs(
    branch = "gh-pages",
    latest = "master",
    julia = "0.6",
    repo = "github.com/EtymoIO/EvolvingGraphs.jl.git"
)
