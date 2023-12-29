
function parseInput(f)
    readlines(f)
end

function vSlice(map, col)
    s = ""
    for line in map
        s = s*line[col]
    end
    s
end

function mapIndexes(maze)
    indexes = []
    for (i, line) in enumerate(maze)
        for (j,c) in enumerate(line)
            c == '#' && push!(indexes, (i,j))
        end
    end
    indexes
end

function emptyRCs(maze)
    rows = [] ; cols = []
    for (i, line) in enumerate(maze)
        !occursin("#", line) && push!(rows, i)
    end
    for j in 1:length(maze[1])
        !occursin("#", vSlice(maze, j)) && push!(cols, j)
    end
    (rows, cols)
end

function distance(f, N)
    maze = parseInput(f)
    indexes = mapIndexes(maze)
    eRows, eCols = emptyRCs(maze)
    total = 0
    for (i, from) in enumerate(indexes)
        for j in i+1:length(indexes)
            to = indexes[j]
            miny = min(from[2], to[2])
            maxy = max(from[2], to[2])
            total += (to[1]-from[1]) + (maxy-miny)
            # exapnd
            nRows = length(filter(x -> x > from[1] && x < to[1], eRows)) 
            nCols = length(filter(y -> y > miny && y < maxy, eCols))
            total += N*nRows - nRows
            total += N*nCols - nCols
        end
    end
    total
end

@show distance("data/11_input.txt", 2)
@show distance("data/11_input.txt", 1000000)