
using DataStructures, Printf, DelimitedFiles

function parseInput(f)
    m = [[parse(Int, i) for i in line] for line in readlines(f)]
    permutedims(hcat(m...))
end

function part1(f)
    matrix = parseInput(f)
    r = size(matrix)[1] ; c = size(matrix)[2]
    targets = [(r,c,'E'), (r,c,'S')]
    sources = [(1, 1, '*')]
    #sum(matrix[y,x] for (x, y) in astar(matrix, targets, sources))
    p = astar(matrix, targets, sources)
    @printf("p = %s\n", p)
    (p, sum(matrix[x,y] for (x, y) in p))
end

function part2(f)
    m = parseInput(f)
    m
end

function distance(a, b)
    sum(abs(a[i] - b[i]) for i in 1:2)
end

function astar(matrix, targets, sources)
    function neighbors(position, path)
        (x, y) = position
        candidates = [(x - 1, y, 'N'), (x + 1, y, 'S'), (x, y - 1, 'W'), (x, y + 1, 'E')]
        # check path for 3 steps in row in same direction
        l=length(path)
        # 3 vertical / horiontal
        (l>=3 && (path[l][1] == path[l-1][1] == path[l-2][1]) && (path[l][3] == path[l-1][3] == path[l-2][3])) && (candidates = [(x - 1, y, 'N'), (x + 1, y, 'S')])
        (l>=3 && (path[l][2] == path[l-1][2] == path[l-2][2]) && (path[l][3] == path[l-1][3] == path[l-2][3])) && (candidates = [(x, y - 1, 'W'), (x, y + 1, 'E')])
        [(x,y,d) for (x,y,d) in candidates if (x >= 1 && x <= size(matrix)[1] && y >= 1 && y <= size(matrix)[2])]
    end

    function evaluate(path)
        f = sum(matrix[x,y] for (x, y) in path)
        h = minimum([distance(path[end], target) for target in targets])
        f + h
    end

    targets = Set(targets)
    frontier = Set([(x,y) for (x,y,_) in sources])
    explored = Set()
    frontier_queue = PriorityQueue()
    for source in sources
        path = [source]
        push!(frontier_queue, path => (evaluate(path)))
    end

    while length(frontier) > 0
        path = dequeue!(frontier_queue)
        cur = path[end]
        curxy = (cur[1], cur[2])
        #println(length(frontier_queue))
        delete!(frontier,curxy)
        push!(explored, curxy)
        path[end] in targets && return path
        for neighbor in neighbors(path[end], path)
            n = (neighbor[1], neighbor[2])
            ((n in frontier) && (n in explored)) && continue
            push!(frontier,n)
            new_path = push!(copy(path), neighbor)
            push!(frontier_queue, new_path => (evaluate(new_path)))
        end
    end
end

@time @show part1("data/17_input_ex.txt")
# @time @show part2("data/17_input.txt")

