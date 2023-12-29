using Memoize

strToInt(line) = [parse(Int,i) for i in split(line, ",") if strip(i) != ""]

function parseInput(f)
    input = []
    for line in readlines(f)
        tape, idx = split(strip(line), " ")
        push!(input, (tape, strToInt(idx)))
    end
    input
end

# t = tape
# p = partitions,
# ti = tapeIndex
# pi = partitionIndex
# cpl = length of current partition '#'
@memoize function arrangements(t, p, ti, pi, cpl)
    if ti > length(t)
        pi > length(p) && cpl == 0 && (return 1)
        pi == length(p) && p[pi] == cpl && (return 1)
        return 0
    end
    total = 0
    if t[ti] == '.' || t[ti] == '?'
        cpl == 0 && (total += arrangements(t, p, ti+1, pi, 0))
        cpl>0 && pi <= length(p) && p[pi] == cpl && (total += arrangements(t, p, ti+1, pi+1, 0))
    end
    if t[ti] == '#' || t[ti] == '?'    
        (total += arrangements(t, p, ti+1, pi, cpl+1))
    end
    total
end

function part1(f)
    total = 0
    for (tape,partition) in parseInput(f)
        total += arrangements(tape, partition, 1, 1, 0)
    end
    total
end

function part2(f)
    total = 0
    for (t,p) in parseInput(f)
        tape = t ; partition = copy(p)
        for _ in 1:4
            tape = tape*"?"*t
            append!(partition, p)
        end
        total += arrangements(tape, partition, 1, 1, 0)
    end
    total
end

@time @show part1("data/12_input.txt")
@time @show part2("data/12_input.txt")