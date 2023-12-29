function parseTurns(turns)
    r = [0,0,0] # R G B
    for turn in turns
        n, c = split(strip(turn), " ")
        n = parse(Int, n)
        # could use a Dict but only 3 colours
        occursin("red", c) && (r[1] = n)   
        occursin("green", c) && (r[2] = n)  
        occursin("blue", c) && (r[3] = n)
    end
    r
end

function parseGames(f)
    games = []
    for line in readlines(open(f))
        _, gamedata = split(line, ":")
        gamedata = split(gamedata, ";")
        game = [parseTurns(split(g, ",")) for g in gamedata]
        push!(games, game)
    end
    games
end

function part1(f) 
    total = 0
    for (gameno, game) in enumerate(parseGames(f))
        possible = true
        for round in game
            round[1] > 12 && (possible = false)
            round[2] > 13 && (possible = false)
            round[3] > 14 && (possible = false)
            possible || break
        end
        possible && (total += gameno)
    end
    total
end

function part2(f) 
    total = 0
    for game in parseGames(f)
        minGame = [0,0,0]
        for round in game
            round[1] > minGame[1] && (minGame[1] = round[1])
            round[2] > minGame[2] && (minGame[2] = round[2])
            round[3] > minGame[3] && (minGame[3] = round[3])
        end
        total += prod(minGame)
    end
    total
end

@show part1("data/02_input.txt")
@show part2("data/02_input.txt")