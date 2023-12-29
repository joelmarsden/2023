using Graphs, GraphPlot, Compose

function parseInput(f)
    input = []
    for line in readlines(f)
        from, to = split(line, ":")
        push!(input, (from, [strip(t) for t in split(to, " ") if strip(t) != ""]))
    end
    input
end

function buildGraph(input)
    nodeMap = Dict()
    labels = []
    idx = 1
    g = Graph()
    for (from, to) in input
        for t in to
            haskey(nodeMap, from) || (nodeMap[from] = idx; idx+=1; add_vertex!(g); push!(labels, from))
            haskey(nodeMap, t) || (nodeMap[t] = idx; idx+=1; add_vertex!(g);  push!(labels, t))      
            add_edge!(g, nodeMap[from], nodeMap[t])
        end
    end
    (g, nodeMap, labels)
end

function part1(f, cuts)
    input = parseInput(f)
    g, nodeMap, labels = buildGraph(input)
    
    g2 = copy(g)
    for (from, to) in cuts
        rem_edge!(g2, nodeMap[from], nodeMap[to])
    end
 
    (from, to) = cuts[1]
    draw(SVG("output/25b_"*from*".svg", 30cm, 20cm), gplot(g, nodelabel=labels))
    draw(PDF("output/25b_"*from*".pdf", 30cm, 20cm), gplot(g, nodelabel=labels))
    draw(SVG("output/25a_"*from*".svg", 30cm, 20cm), gplot(g2))

    x = dfs_tree(g2, nodeMap[from])
    y = dfs_tree(g2, nodeMap[to])
    (ne(x)+1)*(ne(y)+1) # +1 to include the node we start the dfs search from    
end

@time @show part1("data/25_input_ex.txt", [("hfx","pzl"), ("bvb","cmg"), ("nvd", "jqt")])
@time @show part1("data/25_input.txt", [("bqq","rxt"), ("bgl","vfx"), ("btp", "qxr")])