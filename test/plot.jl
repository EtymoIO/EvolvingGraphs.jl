if VERSION < v"0.5-"
    using Colors
    using Compose

    g = random_evolving_graph(4, 3, 0.5)
    plot(g, 1)
    plot(g, 2)
    save_svg(g, 2, filename="test.svg")
    rm("test.svg")
end
