function parseInput(f) 
    input = []
    for line in readlines(open(f))
        s = "."
        for c in line
            isdigit(c) && (s=s*c ; continue)
            c == '.' && (s=s*c ; continue)
            c == '*' && (s=s*c ; continue)
            s=s*"+"
        end
        s=s*"."
        push!(input,s)
    end
    pushfirst!(input, '.'^length(input[1]))
    push!(input, '.'^length(input[1]))
    input
end

function isConnected(input, r, i, j)
    for rn in (r-1):(r+1)
        for cn in (i-1):(j+1)
            input[rn][cn] == '*' && return true
            input[rn][cn] == '+' && return true
        end
    end
    false
end

function part1(f)
    total = 0
    input = parseInput(f)
    for (i,line) in enumerate(input)
        j = 0
        while j<length(line)
            j+=1
            c = line[j]
            (c == '.' || c == '*' || c == '+') && continue
            sd = j
            while isdigit(line[j])
                j += 1
            end
            ed = j-1
            d = parse(Int,line[sd:ed])
            isConnected(input, i, sd, ed) && (total += d)
        end
    end
    total
end

function getNum(input, i, j)
    r = i ; c = j
    n = ""
    while isdigit(input[r][c])
        n = input[r][c] * n
        c -= 1
    end
    c = j + 1
    while isdigit(input[r][c])
        n = n * input[r][c]
        c += 1
    end
    !isempty(n) ? parse(Int, n) : 0
end

function gearNumber(input, i, j)
    gears = []
    isdigit(input[i-1][j-1]) && push!(gears, getNum(input, i-1, j-1))
    (!isdigit(input[i-1][j-1]) && isdigit(input[i-1][j])) && push!(gears, getNum(input, i-1, j))
    (!isdigit(input[i-1][j]) && isdigit(input[i-1][j+1])) && push!(gears, getNum(input, i-1, j+1))
    isdigit(input[i][j-1]) && push!(gears, getNum(input, i, j-1))
    isdigit(input[i][j+1]) && push!(gears, getNum(input, i, j+1))
    isdigit(input[i+1][j-1]) && push!(gears, getNum(input, i+1, j-1))
    (!isdigit(input[i+1][j-1]) && isdigit(input[i+1][j])) && push!(gears, getNum(input, i+1, j))
    (!isdigit(input[i+1][j]) && isdigit(input[i+1][j+1])) && push!(gears, getNum(input, i+1, j+1))
    length(gears) == 2 ? prod(gears) : 0
end

function part2(f)
    total = 0
    input = parseInput(f)
    for (i,line) in enumerate(input)
        for (j, c) in enumerate(line)
            (c != '*') && continue
            total += gearNumber(input, i, j)
        end
    end
    total
end

@show part1("data/03_input.txt")
@show part2("data/03_input.txt")