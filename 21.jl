
parseInput(f) = permutedims(hcat(map(collect, readlines(f))...))

function isGarden(m, x, y)
    (x < 1 || x > size(m,1) || y < 1 || y > size(m,2)) && (return false)
    m[x,y] == '.' || m[x,y] == 'S'
end

function part1(f, cnt)
    m = parseInput(f)
    st = findfirst(x->x=='S', m)
    gardens = Set()
    push!(gardens, (st[1],st[2]))
    for _ in 1:cnt
        nextGardens = Set()
        for (x,y) in gardens
            isGarden(m, x, y-1) && push!(nextGardens, (x,y-1))
            isGarden(m, x, y+1) && push!(nextGardens, (x,y+1))
            isGarden(m, x-1, y) && push!(nextGardens, (x-1,y))
            isGarden(m, x+1, y) && push!(nextGardens, (x+1,y))
        end
        gardens = nextGardens
    end
    length(gardens)
end

function part2(f)
    parseInput(f)
end

@time @show part1("data/21_input.txt", 64)
#@time @show part2("data/21_input.txt")