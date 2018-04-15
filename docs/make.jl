using Documenter, EvolvingGraphs, EvolvingGraphs.Centrality

makedocs(
    format=:html,
    sitename="EvolvingGraphs.jl",
    authors = "Weijian Zhang",
    source= "src",
    modules=[EvolvingGraphs, EvolvingGraphs.Centrality],
    pages=[
    "Home" =>"index.md",
    "Manual" => [
                "examples.md",
                "base.md",
                "graph_types.md",
                "centrality.md",
                "read_write.md",
                "algorithms.md"
                ]
    ]
)

deploydocs(
    branch = "gh-pages",
    latest = "master",
    julia = "0.6",
    target = "build",
    deps = nothing,
    make = nothing,
    repo = "github.com/EtymoIO/EvolvingGraphs.jl.git"
)
