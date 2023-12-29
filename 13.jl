
function parseInput(f)
    maps = [] ; m = []
    for line in readlines(open(f))
        line = strip(line)
        if line == ""
            if length(m) > 0
                m = map(collect, m)
                push!(maps, permutedims(hcat(m...)))
            end
            m = []
            continue
        end
        push!(m, line)
    end
    length(m) > 0 && (m = map(collect, m) ; push!(maps, permutedims(hcat(m...))))
    maps
end

function reflectIdxH(m)
    l = length(m[:,1])
    idx = []
    for r in 1:l-1
        (m[r,:] == m[r+1,:]) && push!(idx, r)
    end
    idx
end

function isReflectHSmudge(m, idx, smudges)
    l = length(m[:,1])
    x = idx ; y = idx+1 ; diffCount = 0
    while x>=1 && y<=l && diffCount <= smudges
        for c in 1:size(m)[2]
            m[x,c] != m[y,c] && (diffCount += 1)
        end
        x-=1; y+=1
    end
    diffCount == smudges
end

function reflectIdxV(m)
    l = length(m[1,:])
    idx = []
    for c in 1:l-1
        (m[:,c] == m[:,c+1]) && push!(idx, c)
    end
    idx
end

function isReflectVSmudge(m, idx, smudges)
    l = length(m[1,:])
    x = idx ; y = idx+1 ; diffCount = 0
    while x>=1 && y<=l && diffCount <= smudges
        for r in 1:size(m)[1]
            m[r,x] != m[r,y] && (diffCount += 1)
        end
        x-=1; y+=1
    end
    diffCount == smudges
end

function part1(f)
    total = 0
    for map in parseInput(f)
        for idx in reflectIdxH(map)
            isReflectHSmudge(map, idx, 0) && (total += 100idx)
        end
        for idx in reflectIdxV(map)
            isReflectVSmudge(map, idx, 0) && (total += idx)
        end
    end
    total
end

function part2(f)
    total = 0
    for map in parseInput(f)
        for idx in 1:size(map)[1]
            isReflectHSmudge(map, idx, 1) && (total += 100idx)
        end
        for idx in 1:size(map)[2]
            isReflectVSmudge(map, idx, 1) && (total += idx)
        end
    end
    total
end

@time @show part1("data/13_input.txt")
@time @show part2("data/13_input.txt")