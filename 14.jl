
parseInput(f) = permutedims(hcat(map(collect, readlines(f))...))

slideNorth(m) = slideUpDown(m, true)
slideSouth(m) = slideUpDown(m, false)
slideEast(m) = slideLeftRight(m, false)
slideWest(m) = slideLeftRight(m, true)

function slideUpDown(m, isUp)
    yy = '.' ; zz = 'O'
    !isUp && (yy = 'O' ; zz = '.')
    cols = length(m[1,:])
    for c in 1:cols
        l = length(m[:,c])
        found = true
        while found
            found = false
            for i in 1:l-1
                if m[i,c] == yy && m[i+1,c] == zz
                    m[i,c] = zz ; m[i+1,c] = yy
                    found = true ; break
                end
            end
        end
    end
    m
end

function slideLeftRight(m, isLeft)
    yy = '.' ; zz = 'O'
    !isLeft && (yy = 'O' ; zz = '.')
    rows = length(m[:,1])
    for r in 1:rows
        l = length(m[r,:])
        found = true
        while found
            found = false
            for i in 1:l-1
                if m[r,i] == yy && m[r,i+1] == zz
                    m[r,i] = zz ; m[r,i+1] = yy
                    found = true ; break
                end
            end
        end
    end
    m
end

function calcLoad(m)
    total = 0
    cols = length(m[1,:])
    for col in 1:cols
        height = length(m[:,col])
        for i in 1:height
            m[i,col] == 'O' && (total += height-i+1)
        end
    end
    total
end

part1(f) = calcLoad(slideNorth(parseInput(f)))

function part2(f)
    m = parseInput(f)
    mats = []
    while true
        m = slideEast(slideSouth(slideWest(slideNorth(m))))
        idx = findall(x -> x == m, mats)
        if length(idx) == 2 # cycling detected
            st = idx[1]
            rep = idx[2] - idx[1]
            rem = 1000000000 - st - 1
            loc = (rem % rep) + 1 # loc + 1 (julia 1 index based)
            return calcLoad(mats[st+loc])
            return mats
        end
        push!(mats, copy(m))
    end
end

@time @show part1("data/14_input.txt")
println()
@time @show part2("data/14_input_ex.txt")
println()
@time @show part2("data/14_input.txt")