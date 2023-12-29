using IterTools

strToInt(line) = [parse(Int,i) for i in split(line, " ") if strip(i) != ""]

function parseInput(f)
    [strToInt(line) for line in readlines(open(f))]
end

function part1(f) 
    total = 0
    for game in parseInput(f)
        g = game
        t = game[end]
        while true
            diffg = []
            for (prev,next) in partition(g,2,1)
                push!(diffg, next-prev)
            end
            t += diffg[end]
            sum(diffg) == 0 && break
            g = diffg
        end
        total += t
    end
    total
end

function part2(f) 
    total = 0
    for game in parseInput(f)
        g = game
        rounds = []
        push!(rounds, game)
        while true
            diffg = []
            for (prev,next) in partition(g,2,1)
                push!(diffg, next-prev)
            end    
            push!(rounds, diffg)
            sum(diffg) == 0 && break
            g = diffg
        end
        t = 0
        for round in reverse(rounds)
            t = round[1] - t
        end
        total += t
    end
    total
end

@show part1("data/09_input.txt")
@show part2("data/09_input.txt")