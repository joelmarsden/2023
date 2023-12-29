using Printf

function parseInput(f)
    lines = map(collect, readlines(f))
    permutedims(hcat(lines...))
end

function nextIdx(maze, pi, pj, i, j)
    p = maze[i,j]
    p == '|' && return ((pi,pj) != (i-1,j)) ? (i-1,j) : (i+1,j)
    p == '-' && return ((pi,pj) != (i,j+1)) ? (i,j+1) : (i,j-1)
    p == 'L' && return ((pi,pj) != (i,j+1)) ? (i,j+1) : (i-1,j)
    p == 'J' && return ((pi,pj) != (i-1,j)) ? (i-1,j) : (i,j-1)
    p == '7' && return ((pi,pj) != (i+1,j)) ? (i+1,j) : (i,j-1)
    p == 'F' && return ((pi,pj) != (i,j+1)) ? (i,j+1) : (i+1,j)
    @assert false
end

function part1(f, S)
    maze = parseInput(f)
    sIdx = findfirst(x->x=='S', maze)
    maze[sIdx] = S  # pass in rather than work out
    prevI = -1 ; prevJ = -1;  i = sIdx[1] ; j = sIdx[2] ; steps = 0
    while true
        steps += 1
        nextI, nextJ = nextIdx(maze, prevI, prevJ, i, j)
        (nextI == sIdx[1] && nextJ == sIdx[2]) && break
        prevI = i ; prevJ = j ; i = nextI ; j = nextJ
    end
    steps÷2 # furthest is halfway around loop
end

function part2(f, S) 
end

@show part1("data/10_input.txt", '7')
#@show part2("data/10_input.txt")

# | is a vertical pipe connecting north and south.
# - is a horizontal pipe connecting east and west.
# L is a 90-degree bend connecting north and east.
# J is a 90-degree bend connecting north and west.
# 7 is a 90-degree bend connecting south and west.
# F is a 90-degree bend connecting south and east.
# . is ground; there is no pipe in this tile.
# S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.