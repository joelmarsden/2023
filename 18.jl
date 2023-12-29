
using IterTools, Printf, DataStructures

parseInput(f) = [(Char(dir[1]), parse(Int,dist), color) for (dir, dist, color) in (split(line, " ") for line in readlines(f))]

function inside(mat, x, y)
    mat[x,y] > 0 && (return false)
    y_count = 0
     for i in 1:x
        mat[i,y] == 1 && (y_count+=1)
    end
    x_count = 0
    for i in 1:y
        mat[x,i] == 1 && (x_count+=1)
    end
    #@printf("\t%d %d\n", x_count, y_count)
    (x_count%2 == 1) && (y_count%2 == 1)
end

function part1(f)
    perim = [(1,1)]
    for instr in parseInput(f)
        (x,y) = (perim[end])
        instr[1] == 'R' && push!(perim,(x,y+instr[2]))
        instr[1] == 'L' && push!(perim,(x,y-instr[2]))
        instr[1] == 'U' && push!(perim,(x-instr[2],y))
        instr[1] == 'D' && push!(perim,(x+instr[2],y))
    end

    xshift = sort(by=x->x[1],perim)[1][1]
    xshift = xshift < 0 ? (1-xshift) : 0
    yshift = sort(by=x->x[2],perim)[1][2]
    yshift = yshift < 0 ? (1-yshift) : 0
    perim = [(x+xshift, y) for (x,y) in perim]
    perim = [(x, y+yshift) for (x,y) in perim]

    mat = zeros(Int, maximum(perim)[1], sort(by=x->x[2],perim)[end][2])
    for (s,f) in partition(perim,2,1)
        for x in min(s[1],f[1]):max(s[1],f[1])
            mat[x,s[2]] = 1
        end
        for y in min(s[2],f[2]):max(s[2],f[2])
            mat[s[1],y] = 1
        end
    end
    ix = 0 ; iy = 0
    for r in 1:size(mat,1)
        for c in 1:size(mat,2)
            inside(mat,r,c) && (ix=r; iy=c; break)
        end
        ix > 0 && iy > 0 && break
    end

    # flood fill
    floodfill!(mat, size(mat,1),size(mat,2),ix,iy,0,1)
    sum(mat)
end

function part2(f)
    perim = [(1,1)]
    for instr in parseInput(f)
        (x,y) = (perim[end])
        len = parse(Int, instr[3][3:7], base=16)
        dir = parse(Int,instr[3][8])
        dir == 0 && push!(perim,(x,y+len)) #R
        dir == 2 && push!(perim,(x,y-len)) #L
        dir == 3 && push!(perim,(x-len,y)) #U
        dir == 1 && push!(perim,(x+len,y)) #D
    end
    xshift = sort(by=x->x[1],perim)[1][1]
    xshift = xshift < 0 ? (1-xshift) : 0
    yshift = sort(by=x->x[2],perim)[1][2]
    yshift = yshift < 0 ? (1-yshift) : 0
    perim = [(x+xshift, y) for (x,y) in perim]
    perim = [(x, y+yshift) for (x,y) in perim]
    perim
end

function isValid(screen, m, n, x, y, prevC, newC)
    !(x<1 || x> m || y<1 || y> n || screen[x,y] != prevC || screen[x,y] == newC)
end

function floodfill!(screen, m, n, x, y, prevC, newC)
    queue = []
     
    # Append the position of starting 
    # pixel of the component
    push!(queue,(x, y))
 
    # Color the pixel with the new color
    screen[x,y] = newC
 
    # While the queue is not empty i.e. the 
    # whole component having prevC color 
    # is not colored with newC color
    while length(queue) > 0
        # Dequeue the front node
        currPixel = popfirst!(queue)
         
        posX = currPixel[1]
        posY = currPixel[2]
         
        # Check if the adjacent
        # pixels are valid
        if isValid(screen, m, n, posX + 1, posY, prevC, newC)
            # Color with newC
            # if valid and enqueue
            screen[posX + 1,posY] = newC
            push!(queue,(posX + 1, posY))
        end
         
        if isValid(screen, m, n, posX-1, posY, prevC, newC)
            screen[posX-1,posY]= newC
            push!(queue,(posX-1, posY))
        end
         
        if isValid(screen, m, n, posX, posY + 1, prevC, newC)
            screen[posX,posY + 1]= newC
            push!(queue,(posX, posY + 1))
        end
         
        if isValid(screen, m, n, posX, posY-1, prevC, newC)
            screen[posX,posY-1]= newC
            push!(queue,(posX, posY-1))
        end
    end
end

@time @show part1("data/18_input.txt")
@time @show part2("data/18_input.txt")