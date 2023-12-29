
function parseInput(f)
    input = []
    for line in readlines(open(f))
        append!(input, split(line, ","))
    end
    input
end

function hash(token)
    h = 0
    for c in token
        h = (h+Int(c))*17%256
    end
    h
end

part1(f) = sum(hash(token) for token in parseInput(f))

function part2(f)
    boxes = Dict()
    for token in parseInput(f)
        if occursin("-", token)
            label, _ = split(token, "-")
            h = hash(label)
            if haskey(boxes, h)
                lenses = boxes[h]
                deleteat!(lenses, findall(x -> x[1] == label, lenses))
            end
        end
        if occursin("=", token)
            label, power = split(token, "=")
            power = parse(Int,power)
            h = hash(label)
            haskey(boxes, h) || (boxes[h] = [])
            lenses = boxes[h]
            idx = findfirst(x -> x[1] == label, lenses)
            !isnothing(idx) ? lenses[idx] = (label, power) : push!(lenses, (label, power))
        end
    end
    total = 0
    for (box, lenses) in boxes
        for (slot, lens) in enumerate(lenses)
            total += (box+1)*slot*lens[2]
        end
    end
    total
end

@time @show part1("data/15_input.txt")
@time @show part2("data/15_input.txt")