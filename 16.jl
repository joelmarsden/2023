
parseInput(f) = permutedims(hcat(map(collect, readlines(f))...))

function nextLoc(m, i, j, dir)
    if dir=='N'
        i == 1 && return [(i-1,j, 'N')]
        tile = m[i-1,j]
        (tile == '.' || tile == '|') && return [(i-1,j, 'N')]
        (tile == '\\') && return [(i-1,j,'W')]
        (tile == '/') && return [(i-1,j,'E')]
        (tile == '-') && return [(i-1,j, 'E'),(i-1,j, 'W')]
    end
    if dir=='S'
        i == size(m)[1] && return [(i+1,j, 'N')]
        tile = m[i+1,j]
        (tile == '.' || tile == '|') && return [(i+1,j, 'S')]
        (tile == '\\') && return [(i+1,j,'E')]
        (tile == '/') && return [(i+1,j,'W')]
        (tile == '-') && return [(i+1,j, 'E'),(i+1,j, 'W')]
    end
    if dir=='E'
        j == size(m)[2] && return [(i,j+1, 'E')]
        tile = m[i,j+1]
        (tile == '.' || tile == '-') && return [(i,j+1, 'E')]
        (tile == '\\') && return [(i,j+1,'S')]
        (tile == '/') && return [(i,j+1,'N')]
        (tile == '|') && return [(i,j+1, 'N'),(i,j+1, 'S')]
    end
    if dir=='W'
        j == 1 && return [(i,j-1, 'W')]
        tile = m[i,j-1]
        (tile == '.' || tile == '-') && return [(i,j-1, 'W')]
        (tile == '\\') && return [(i,j-1,'N')]
        (tile == '/') && return [(i,j-1,'S')]
        (tile == '|') && return [(i,j-1, 'N'),(i,j-1, 'S')]
    end
    @assert false
end

function energisedCnt(m, startLoc)
    beams = [startLoc] # initial beam
    visited = [[] for _ in 1:size(m)[1], _ in 1:size(m)[2]]
    while length(beams) > 0
        nextBeams = []
        for beam in beams
            for loc in nextLoc(m, beam[1], beam[2], beam[3])
                (loc[1] <= 0 || loc[1] > size(m)[1]) && continue
                (loc[2] <= 0 || loc[2] > size(m)[2]) && continue
                vTile = visited[loc[1],loc[2]]
                !isnothing(findfirst(x->x==loc[3], vTile)) && continue
                push!(vTile, loc[3])
                push!(nextBeams, loc)
            end
        end
        beams = nextBeams
    end
    # count up where we went
    #[(length(v)>0 ? '#' : '.') for v in visited]
    sum(1 for v in visited if length(v) > 0)
end

part1(f) = energisedCnt(parseInput(f), (1,0,'E'))

function part2(f)
    m = parseInput(f)
    maxE = maximum([energisedCnt(m, (0,j,'S')) for j in 1:size(m)[2]])
    maxE = max(maxE, maximum([energisedCnt(m, (size(m)[1]+1,j,'N')) for j in 1:size(m)[2]]))
    maxE = max(maxE, maximum([energisedCnt(m, (i,0,'E')) for i in 1:size(m)[1]]))
    max(maxE, maximum([energisedCnt(m, (i,size(m)[2]+1,'W')) for i in 1:size(m)[1]]))
end

@time @show part1("data/16_input.txt")
@time @show part2("data/16_input.txt")