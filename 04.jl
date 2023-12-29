strToInt(line) = [parse(Int,i) for i in split(line, " ") if strip(i) != ""]

function parseGames(f)
    games = []
    for (n, line) in enumerate(readlines(open(f)))
        _, carddata = split(line, ":")
        winning, chosen = split(carddata, "|")
        push!(games,(n, strToInt(winning),strToInt(chosen)))
    end
    games
end

function part1(f) 
    total = 0
    for game in parseGames(f)
        won = length(intersect(game[2], game[3]))
        total += won > 0 ? 2^(won-1) : 0
    end
    total
end

function part2(f) 
    games = parseGames(f)
    totals = ones(Int,length(games))
    for (n, game) in enumerate(games)
        won = length(intersect(game[2], game[3]))  
        for c in n+1:n+won
            totals[c] += totals[n]
        end
    end
    sum(totals)
end

@show part1("data/04_input.txt")
@show part2("data/04_input.txt")