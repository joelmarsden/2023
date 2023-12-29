using Printf

struct Pmap
    dest::Int
    src::Int
    cnt::Int
end
    
strToInt(line) = [parse(Int,i) for i in split(line, " ") if strip(i) != ""]

function parseSeeds(line)
    _, seeds = split(line, ":")
    strToInt(seeds)
end

function parseInstructions(f)
    seeds = []
    mappings = Vector{Vector{Pmap}}()
    currentmap = Vector{Pmap}()
    for (n, line) in enumerate(readlines(open(f)))
        strip(line) == "" && continue
        occursin("seeds:", line) && (seeds = parseSeeds(line) ; continue)
        if occursin(":", line)
            sort!(currentmap, by = s -> s.src)
            length(currentmap) > 0 && push!(mappings, currentmap)
            currentmap = []
            continue
        end
        m = strToInt(line)
        push!(currentmap, Pmap(m[1], m[2], m[3]))
    end
    sort!(currentmap, by = s -> s.src)
    length(currentmap) > 0 && push!(mappings, currentmap)
    (seeds, mappings)
end

function mapsTo(n, m::Pmap)
    m.src > n && return -1
    n > (m.src + m.cnt - 1) && return -1
    m.dest + (n-m.src)
end

function mapsTo(n, ma::Vector{Pmap})
    for p in ma
        m = mapsTo(n, p)
        m > 0 && return m
    end
    n
end

function part1(f) 
    seeds, instructions = parseInstructions(f)
    locations = []
    for seed in seeds
        m = seed
        for ins in instructions
            m = mapsTo(m, ins)
        end
        push!(locations, m)
    end
    minimum(locations)
end

function part2(f)  # slow - need to think of better way (back to front?)
    seeds, instructions = parseInstructions(f)
    minloc = typemax(Int)
    for i in 1:2:length(seeds)
        st = seeds[i] ; rng = seeds[i+1]
        for seed in st:(st+rng-1)
            m = seed
            for ins in instructions
                m = mapsTo(m, ins)
            end
            m < minloc && (minloc = m; @printf("New min is: %d\t from %d + (%d+%d)\n", m, seed, st, (seed-st)))
        end
    end
    minloc
end

@show part1("data/05_input.txt")
# 358.881965 seconds (18.35 G allocations: 300.851 GiB, 3.69% gc time, 0.04% compilation time)
@time @show part2("data/05_input.txt")